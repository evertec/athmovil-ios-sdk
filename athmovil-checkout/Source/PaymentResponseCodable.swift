//
//  PaymentResponseCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentResponseCodable: Decodable {
    
    associatedtype Payment: PaymentCodable
    associatedtype Status: PaymentStatusCodable
    associatedtype Customer: CustomerCodable
    
    var paymentResponse: Payment { get }
    var statusResponse: Status { get }
    var customerResponse: Customer { get }
}


struct PaymentResponseCoder: PaymentResponseCodable{
    
    /// Current payment, it is the same object that the client have been sent in the request
    let paymentResponse: PaymentCoder

    /// Status of the payment completed, expired o cancelled and other purchase's properties
    let statusResponse: PaymentStatusCoder

    ///Customer owner
    let customerResponse: CustomerCoder
    
    let status: ATHMPaymentStatus
    let payment: ATHMPayment
    let customer: ATHMCustomer
    
    init(from decoder: Decoder) throws {
        do {
            
            self.customerResponse = try CustomerCoder(from: decoder)
            self.customer = customerResponse.customer

            self.paymentResponse = try PaymentCoder(from: decoder)
            self.payment = paymentResponse.payment
            
            self.statusResponse = try PaymentStatusCoder(from: decoder)
            self.status = statusResponse.statusPayment
            
        }catch let exception{
            throw exception
        }
    }
}


