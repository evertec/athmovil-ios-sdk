//
//  PaymentHandleable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 9/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentHandleable {

    /// Unique identifier per request
    var traceId: UUID { get }
    
    /// It is going to call when the there is error in the request or in the response from ATH Movil
    var onException: (ATHMPaymentError) -> Void { get set }
    
    /// Method to confirm the payment to ATH Movil
    /// - Parameter data: data form the url it must containts the required properties otherwise will call onexception closure
    func completeFrom(data: Data)
    
    /// Method to complete the transaction after the web service response with a transaction
    /// - Parameter serverPayment: current response of the web service ATHMPaymentHandler and ATHMPaymentHandlerDictionary implements this method in differente way
    func completeFrom(serverPayment: ATHMPaymentResponse)
}
