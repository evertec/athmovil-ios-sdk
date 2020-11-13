//
//  ATHMPurchaseResponse.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/19/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation



@objc(ATHMPaymentResponse)
public class ATHMPaymentResponse: NSObject{
        
    /// Current payment, it is the same object that the client have been sent in the request
    @objc public let payment: ATHMPayment

    /// Status of the payment completed, expired o cancelled and other purchase's properties
    @objc public let status: ATHMPaymentStatus

    ///Customer owner
    @objc public let customer: ATHMCustomer

    
    @objc public override var description: String{
        """
        Response:
        \(payment.description)
        \(customer.description)
        \(status.description)
        """
    }
    
    
    required init(payment: ATHMPayment, status: ATHMPaymentStatus, customer: ATHMCustomer) {
        self.payment = payment
        self.customer = customer
        self.status = status
    }
}

