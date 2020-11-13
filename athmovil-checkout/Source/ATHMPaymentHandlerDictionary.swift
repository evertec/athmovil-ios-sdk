//
//  ATHMPaymentHandlerDictionary.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 9/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


@objc(ATHMPaymentHandlerDictionary)
public class ATHMPaymentHandlerDictionary: NSObject{

    
    ///Closure the completed transaction, it is going to call when ath movil returns a completed transaction
    var onCompleted: (_ response: NSDictionary) -> ()
    
    ///Closure the completed transaction, it is going to call when ath movil returns a expired transaction
    var onExpired: (_ response: NSDictionary) -> ()
    
    ///Closure the completed transaction, it is going to call when ath movil returns a canceled transaction
    var onCancelled: (_ response: NSDictionary) -> ()
    
    ///it is going to call when the there is error in the request or in the response from ATH Movil
    var onException: (_ response: ATHMPaymentError) -> ()
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.S"
        
        return dateFormatter
    }()
    
    /**
     Creates an instance of the handler payment
     - Parameters:
         - completed: Closure to call after ATH Movil completed the payment
         - expired: Closure to call after ATH Movil expire the payment
         - cancelled: Closure to call after ATH Movil cancelled the payment
     */
    @objc public init(onCompleted: @escaping ((_ response:NSDictionary) -> ()),
                      onExpired: @escaping (_ response: NSDictionary) -> (),
                      onCancelled: @escaping (_ response: NSDictionary) -> (),
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
        decoder.dateDecodingStrategy = .formatted(ATHMPaymentHandlerDictionary.dateFormatter)
        
        do{
            
            let dictionaryResponse = try JSONSerialization.jsonObject(with: athMovilData,
                                                                      options: .mutableContainers) as? NSDictionary
            let responseDecodable = try decoder.decode(PaymentResponseCoder.self, from: athMovilData)
            let response = ATHMPaymentResponse(payment: responseDecodable.payment,
                                               status: responseDecodable.status,
                                               customer: responseDecodable.customer)
            

            complete(paymentStatus: response.status.status, response: dictionaryResponse)
            
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
    private func complete(paymentStatus: ATHMStatus, response: NSDictionary?){
        
        switch paymentStatus {
            case .completed:
                onCompleted(response ?? NSDictionary())
            
            case .expired:
                onExpired(response ?? NSDictionary())
            
            default:
                onCancelled(response ?? NSDictionary())
        }
    }
}

extension ATHMPaymentHandlerDictionary: PaymentHandleable{}
