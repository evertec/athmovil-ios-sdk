//
//  PaymentSimulated.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/20/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

extension PaymentSimulated: PaymentRequestable { }

extension PaymentSimulated: PaymentRequestCodable {
    enum CodingKeys: CodingKey {
        case businessAccount, scheme, payment, timeout
    }
}

struct PaymentSimulated {
    
    /// Business account if the token account it is empty you will received an exception
    let businessAccount: ATHMBusinessAccount
    
    /// Current application that will send the request to ATH Móvil Personal
    let scheme: ATHMURLScheme
    
    /// Purchase representation to send to ATH Movil
    let payment: ATHMPayment
        
    /// Purchase Timeout in ath movil personal
    let timeout: TimeInterval
    
    /// Current version of the payment request, it is only for ATH Movil personal
    let version: ATHMVersion
        
    /// Creates an instance of Payment simulated this sctruct will copy all the properties of the ATHMPaymentRequest, this request keeps a fixed token
    /// - Parameter paymentRequest: request of the payment that the client have been send,
    init(paymentRequest: ATHMPaymentRequest) {
        
        self.businessAccount = paymentRequest.businessAccount
        self.scheme = paymentRequest.scheme
        self.payment = paymentRequest.payment
        self.timeout = paymentRequest.timeout
        self.version = paymentRequest.version
    }
}
