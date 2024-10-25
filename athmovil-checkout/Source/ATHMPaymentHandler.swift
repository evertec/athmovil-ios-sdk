//
//  ATHMPaymentHandler.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/24/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentHandler)
public class ATHMPaymentHandler: NSObject {

     /// Closure the completed transaction, it is going to call when ath movil returns a completed transaction
    var onCompleted: (ATHMPaymentResponse) -> Void
    
    /// Closure the completed transaction, it is going to call when ath movil returns a expired transaction
    var onExpired: (ATHMPaymentResponse) -> Void
    
    /// Closure the completed transaction, it is going to call when ath movil returns a canceled transaction
    var onCancelled: (ATHMPaymentResponse) -> Void
    
    /// Closure the completed transaction, it is going to call when ath movil returns a failed transaction
    var onFailed: (ATHMPaymentResponse) -> Void
    
    /// it is going to call when the there is error in the request or in the response from ATH Movil
    var onException: (ATHMPaymentError) -> Void
        
    /// Unique identifier for each request
    internal let traceId: UUID = UUID()
    
    /// Creates an instance of the handler payment
    /// - Parameters:
    ///   - onCompleted: Closure to call after ATH Movil completed the payment
    ///   - onExpired: Closure to call after ATH Movil expire the payment
    ///   - onCancelled: Closure to call after ATH Movil cancelled the payment
    ///   - onFailed: Closure to call after ATH Movil failed the payment
    ///   - onException: Closure to call when there an error en request o response
    /// - Returns: Instance of the handler
    @objc public init(onCompleted: @escaping ((ATHMPaymentResponse) -> Void),
                      onExpired: @escaping (ATHMPaymentResponse) -> Void,
                      onCancelled: @escaping (ATHMPaymentResponse) -> Void,
                      onFailed: @escaping (ATHMPaymentResponse) -> Void,
                      onException: @escaping (ATHMPaymentError) -> Void) {
        
        self.onCompleted = onCompleted
        self.onExpired = onExpired
        self.onCancelled = onCancelled
        self.onFailed = onFailed
        self.onException = onException
        
        super.init()
    }
    
    /// Method to confirm the payment to ATH Movil when the response becomes from url scheme
    /// - Parameter data: data from the URL, it must containts the required properties otherwise will call onexception closure
    func completeFrom(data: Data) {
        
        do {
            
            let responseDecodable = try Data.decoder.decode(PaymentResponseCoder.self, from: data)
            let response = ATHMPaymentResponse(payment: responseDecodable.payment,
                                               status: responseDecodable.status,
                                               customer: responseDecodable.customer)
            
            complete(paymentStatus: response.status.status, response: response)
            
        } catch let exceptionPayment as ATHMPaymentError {
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            onException(paymentException)
            
        } catch  {
            
            let messageError = "Sorry for the inconvenience. Please try again later."
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            onException(paymentException)
        }
        
    }
        
    /// Complete the payment base on the paymentStatus that could be completed, expired or cancelled
    /// - Parameters:
    ///   - paymentStatus: current status of the payment it could be completed, cancelled or expired
    ///   - response: dictionary which containts the keys-values of the response
    private func complete(paymentStatus: ATHMStatus, response: ATHMPaymentResponse) {
        
        switch paymentStatus {
            case .completed:
                onCompleted(response)

            case .expired:
                onExpired(response)
            
            case .failed:
                onFailed(response)

            default:
                onCancelled(response)
        }
    }
}

extension ATHMPaymentHandler: PaymentHandleable {
        
    /// Method to complete the transaction after the web service response with a transaction
    /// - Parameter serverPayment: current response of the web service
    func completeFrom(serverPayment: ATHMPaymentResponse) {
        
        complete(paymentStatus: serverPayment.status.status, response: serverPayment)
    }
}
