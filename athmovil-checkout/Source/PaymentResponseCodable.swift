//
//  PaymentResponseCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentResponseCodable: Model { }

struct PaymentResponseCoder: PaymentResponseCodable {
    
    let status: ATHMPaymentStatus
    let payment: ATHMPayment
    let customer: ATHMCustomer
    
    init(payment: ATHMPayment, customer: ATHMCustomer, status: ATHMPaymentStatus) {
        self.status = status
        self.payment = payment
        self.customer = customer
    }
    
    init(from decoder: Decoder) throws {
        do {
            
            self.customer = try ATHMCustomer(from: decoder)
            self.payment = try ATHMPayment(from: decoder)
            self.status = try ATHMPaymentStatus(from: decoder)

        } catch let exception {
            throw exception
        }
    }
    
    func encode(to encoder: Encoder) throws {
        do {
            try customer.encode(to: encoder)
            try payment.encode(to: encoder)
            try status.encode(to: encoder)
        } catch let exception {
            throw exception
        }
    }
}
