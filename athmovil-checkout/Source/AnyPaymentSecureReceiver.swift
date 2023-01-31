//
//  AnyPaymentSecureReceiver.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 4/10/22.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

struct AnyPaymentSecureReceiver {
    
    enum ChannelSourcePayment {
        case deepLink(Data)
        case becomeActive
    }
    
    let handler: PaymentHandleable
    let paymentRequest: PaymentSecureRequestable
    let clientAPI: APIClientRequestable
    unowned let session: ATHMPaymentSession
    
    init(paymentContent: PaymentSecureRequestable,
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
        let authorization = UserPreferences.shared.authToken
        switch sourceChannel {
            case let .deepLink(responseData):
                if(authorization.isEmpty){
                    ATHMPaymentSession.shared.currentSecurePayment = nil
                    self.handler.completeFrom(data: responseData)
                }else{
                    do {
                        let responseDecodable = try Data.decoder.decode(PaymentResponseCoder.self, from: responseData)
                        let response = ATHMPaymentResponse(payment: responseDecodable.payment,
                                                           status: responseDecodable.status,
                                                           customer: responseDecodable.customer)
                        if(response.status.status == .completed){
                            self.authorization(handler: handler, response: response)
                        }else{
                            ATHMPaymentSession.shared.currentSecurePayment = nil
                            self.handler.completeFrom(data: responseData)
                        }
                    }catch {
                        do {
                            let dictionaryResponse = try JSONSerialization.jsonObject(with: responseData,
                                                                                      options: .mutableContainers) as? NSDictionary
                            let name = dictionaryResponse?["name"] as? String ?? ""
                            let phoneNumber = dictionaryResponse?["phoneNumber"] as? String ?? ""
                            let email = dictionaryResponse?["email"] as? String ?? ""
                            let customer = ATHMCustomer(name: name, phoneNumber: phoneNumber, email: email)
                            let currentSecurePayment = session.currentSecurePayment
                            let statusCancel = ATHMPaymentStatus(status: .cancelled)
                            let response = ATHMPaymentResponse(payment: (currentSecurePayment?.paymentRequest.paymentOld)!,
                                                               status: statusCancel,
                                                               customer: customer)
                            
                            self.handler.completeFrom(serverPayment: response)
                        }catch {
                            let currentSecurePayment = session.currentSecurePayment
                            let statusCancel = ATHMPaymentStatus(status: .cancelled)
                            let response = ATHMPaymentResponse(payment: (currentSecurePayment?.paymentRequest.paymentOld)!,
                                                               status: statusCancel,
                                                               customer: "")
                            
                            self.handler.completeFrom(serverPayment: response)
                        }
                    }
                }
            case .becomeActive:
                if(authorization.isEmpty){
                    session.isWaiting = true
                    getTransactionFromWebService()
                }else{
                    let currentSecurePayment = session.currentSecurePayment
                    let statusPending = ATHMPaymentStatus(status: .pending)
                    let response = ATHMPaymentResponse(payment: (currentSecurePayment?.paymentRequest.paymentOld)!,
                                                       status: statusPending,
                                                       customer: "")
                    self.handler.completeFrom(serverPayment: response)
                }
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
    
    private func authorization(handler: PaymentHandleable, response: ATHMPaymentResponse) {
        clientAPI.send(request: .authorization(completion: { result in
            DispatchQueue.main.sync {
                switch result {
                    case let .success(responseAuthorization):
                        UserPreferences.reset()
                        ATHMPaymentSession.shared.currentSecurePayment = nil
                        //SET PARAMS RESPONSE AUTHORIZATION
                        let dailyTransactionId = Int(responseAuthorization.data.dailyTransactionId) ?? 0
                        response.status.dailyTransactionID = dailyTransactionId
                        response.status.referenceNumber = responseAuthorization.data.referenceNumber
                        self.handler.completeFrom(serverPayment: response)
                    case .failure:
                        response.status.status = .failed
                        self.handler.completeFrom(serverPayment: response)
                }
            }
        }))
    }
}
