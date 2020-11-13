//
//  ATHMPaymentHandler.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/24/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentHandler)
public class ATHMPaymentHandler: NSObject{

    
     ///Closure the completed transaction, it is going to call when ath movil returns a completed transaction
    var onCompleted: (_ response: ATHMPaymentResponse) -> ()
    
    ///Closure the completed transaction, it is going to call when ath movil returns a expired transaction
    var onExpired: (_ response: ATHMPaymentResponse) -> ()
    
    ///Closure the completed transaction, it is going to call when ath movil returns a canceled transaction
    var onCancelled: (_ response: ATHMPaymentResponse) -> ()
    
    ///it is going to call when the there is error in the request or in the response from ATH Movil
    var onException: (_ response: ATHMPaymentError) -> ()
    
    
    /**
     Creates an instance of the handler payment
     - Parameters:
         - completed: Closure to call after ATH Movil completed the payment
         - expired: Closure to call after ATH Movil expire the payment
         - cancelled: Closure to call after ATH Movil cancelled the payment
     */
    @objc public init(onCompleted: @escaping ((_ response: ATHMPaymentResponse) -> ()),
                      onExpired: @escaping (_ response: ATHMPaymentResponse) -> (),
                      onCancelled: @escaping (_ response: ATHMPaymentResponse) -> (),
                      onException: @escaping (_ response: ATHMPaymentError) -> ()){
        
        self.onCompleted = onCompleted
        self.onExpired = onExpired
        self.onCancelled = onCancelled
        self.onException = onException
        
        super.init()
    }
    
    
    /**
     Method to confirm the payment to ATH Movil
     - Parameters:
         - from data form the url
     */
    func confirm(from athMovilData: Data){
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        do{
            
            let responseDecodable = try decoder.decode(PaymentResponseCoder.self, from: athMovilData)
            let response = ATHMPaymentResponse(payment: responseDecodable.payment,
                                               status: responseDecodable.status,
                                               customer: responseDecodable.customer)
            
            complete(paymentStatus: response.status.status, response: response)
            
        }catch let exceptionPayment as ATHMPaymentError{
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            onException(paymentException)
            
        }catch let exception{
            
            let genericException = exception as NSError
            let messageError = "There was an error while decode response. Detail: \(genericException.debugDescription)"
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            onException(paymentException)
        }
        
    }
    
    /**
     Complete the payment base on the paymentStatus that could be completed, expired or cancelled
     - Parameters:
         - paymentStatus current status of the payment it could be completed, cancelled or expired
         - response dictionary which containts the keys-values of the response
     */
    private func complete(paymentStatus: ATHMStatus, response: ATHMPaymentResponse){
        
        switch paymentStatus {
        case .completed:
            onCompleted(response)

        case .expired:
            onExpired(response)

        default:
            onCancelled(response)
        }
    }
}

extension ATHMPaymentHandler: PaymentHandleable{}
