//
//  AnyPaymentReceiver.swift
//  athmovil-checkout
//
//  Created by Hansy on 12/15/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

struct AnyPaymentReceiver {
    
    enum ChannelSourcePayment {
        case deepLink(Data)
        case becomeActive
    }
    
    let handler: PaymentHandleable
    let paymentRequest: PaymentRequestable
    let clientAPI: APIClientRequestable
    unowned let session: ATHMPaymentSession
    
    init(paymentContent: PaymentRequestable,
         handler: PaymentHandleable,
         session: ATHMPaymentSession,
         apiClient: APIClientRequestable) {
        self.handler = handler
        self.paymentRequest = paymentContent
        self.session = session
        self.clientAPI = apiClient
    }
    
    /// Complete the payment from the DeepLink or become Active. When the response comes from the become active set ATHMPaymentSession.isWaiting as
    ///  true avoiding to start a new payment. This method will return the response payment in the main thread so avoid to make a long taks in this method or in the
    ///  decoding
    /// - Parameter sourceChannel: Source of the current respnse. It would be from the DeepLink or become active notificiation. When it is from become active will
    ///  call a web service to get the payment status
    func completed(by sourceChannel: ChannelSourcePayment) {
        
        switch sourceChannel {
            case let .deepLink(responseData):
                handler.completeFrom(data: responseData)

            case .becomeActive:
                session.isWaiting = true
                getTransactionFromWebService()
        }
    }
    
    private func getTransactionFromWebService() {
        clientAPI.send(request: .status(paymentId: handler.traceId.uuidString,
                                        currentPayment: paymentRequest,
                                        completion: { result in
                                            
                                            session.isWaiting = false
                                            
                                            DispatchQueue.main.sync {
                                                switch result {
                                                    case let .success(response):
                                                        self.handler.completeFrom(serverPayment: response)
                                                        
                                                    case let .failure(error):
                                                        self.handler.onException(error)
                                                }
                                            }
                                        }))
    }
}
