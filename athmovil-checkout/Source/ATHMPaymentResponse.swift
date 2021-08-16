//
//  ATHMPurchaseResponse.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/19/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentResponse)
final public class ATHMPaymentResponse: NSObject {
        
    /// Current payment, it is the same object that the client have been sent in the request
    @objc public let payment: ATHMPayment

    /// Status of the payment completed, expired o cancelled and other purchase's properties
    @objc public let status: ATHMPaymentStatus

    /// ATH Móvil's customer
    @objc public let customer: ATHMCustomer

    @objc public override var description: String {
        """
        Response:
            \n
            \(payment.description)
            \n
            \(customer.description)
            \n
            \(status.description)
        """
    }
    
    required init(payment: ATHMPayment, status: ATHMPaymentStatus, customer: ATHMCustomer) {
        self.payment = payment
        self.customer = customer
        self.status = status
    }
}
