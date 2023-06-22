//
//  ATHMPaymentHandlerDictionary.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 9/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentHandlerDictionary)
public class ATHMPaymentHandlerDictionary: NSObject {

    /// Closure the completed transaction, it is going to call when ath movil returns a completed transaction
    var onCompleted: (NSDictionary) -> Void
    
    /// Closure the completed transaction, it is going to call when ath movil returns a expired transaction
    var onExpired: (NSDictionary) -> Void
    
    /// Closure the completed transaction, it is going to call when ath movil returns a canceled transaction
    var onCancelled: (NSDictionary) -> Void
    
    /// Closure the completed transaction, it is going to call when ath movil returns a pending transaction
    var onPending: (NSDictionary) -> Void
    
    /// Closure the completed transaction, it is going to call when ath movil returns a failed transaction
    var onFailed: (NSDictionary) -> Void
    
    /// it is going to call when the there is error in the request or in the response from ATH Movil
    var onException: (ATHMPaymentError) -> Void
        
    /// Unique identifier for each request
    internal let traceId: UUID = UUID()
    
    /// Creates an instance of the handler payment
    /// - Parameters:
    ///   - onCompleted: Closure to call after ATH Movil completed the payment
    ///   - onExpired: Closure to call after ATH Movil expire the payment
    ///   - onCancelled: Closure to call after ATH Movil cancelled the payment
    ///   - onPending: Closure to call after ATH Movil pending the payment
    ///   - onFailed: Closure to call after ATH Movil failed the payment
    ///   - onException: Closure to call when there is an error in the request or response
    ///   - Returns: Returns an instance of handler
    @objc public init(onCompleted: @escaping ((NSDictionary) -> Void),
                      onExpired: @escaping (NSDictionary) -> Void,
                      onCancelled: @escaping (NSDictionary) -> Void,
                      onPending: @escaping (NSDictionary) -> Void,
                      onFailed: @escaping (NSDictionary) -> Void,
                      onException: @escaping (ATHMPaymentError) -> Void) {
        
        self.onCompleted = onCompleted
        self.onExpired = onExpired
        self.onCancelled = onCancelled
        self.onPending = onPending
        self.onFailed = onFailed
        self.onException = onException
        
        super.init()
    }
    
    /// Method to confirm the payment to ATH Movil when the response becomes from url scheme
    /// - Parameter data: data from the URL, it must containts the required properties otherwise will call onexception closure
    func completeFrom(data: Data) {

        do {
            
            let dictionaryResponse = try JSONSerialization.jsonObject(with: data,
                                                                      options: .mutableContainers) as? NSDictionary
            let responseDecodable = try Data.decoder.decode(PaymentResponseCoder.self, from: data)
            let response = ATHMPaymentResponse(payment: responseDecodable.payment,
                                               status: responseDecodable.status,
                                               customer: responseDecodable.customer)
            
            complete(paymentStatus: response.status.status, response: dictionaryResponse)
            
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
    private func complete(paymentStatus: ATHMStatus, response: NSDictionary?) {
        
        switch paymentStatus {
            case .completed:
                onCompleted(response ?? NSDictionary())
            
            case .expired:
                onExpired(response ?? NSDictionary())
            
            case .pending:
                onPending(response ?? NSDictionary())
            
            case .failed:
                onFailed(response ?? NSDictionary())
            
            default:
                onCancelled(response ?? NSDictionary())
        }
    }
}

extension ATHMPaymentHandlerDictionary: PaymentHandleable {
    
    /// Method to complete the transaction after the web service response with a transaction
    /// - Parameter serverPayment: current response of the web service
    func completeFrom(serverPayment: ATHMPaymentResponse) {
        let paymentCodable = PaymentResponseCoder(payment: serverPayment.payment,
                                                  customer: serverPayment.customer,
                                                  status: serverPayment.status)
        
        do {
            let dataPayment = try PaymentResponseCoder.encoder.encode(paymentCodable)
            let jsonResult = try JSONSerialization.jsonObject(with: dataPayment, options: .mutableContainers)
            let jsonDictionary = jsonResult as? NSDictionary
            
            complete(paymentStatus: serverPayment.status.status,
                     response: jsonDictionary)
        } catch {
            let paymentError = ATHMPaymentError(message: "Sorry for the inconvenience. Please try again later.",
                                                source: .response)
            onException(paymentError)
        }
    }
    
}
