//
//  AnyPaymentSecureRequestCoder.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 4/10/22.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentSecureRequestCodable: Encodable {
    
    associatedtype Payment: PaymentSecureCodable

    var payment: Payment { get }
    var timeout: TimeInterval { get }
}

struct AnyPaymentSecureRequestCoder<P>: Encodable where P: PaymentSecureRequestCodable {

    let paymentRequest: P
    
    private enum PaymentRequestCodingKeys: String, CodingKey {
        case timeout = "expiresIn"
    }
    
    /// Encode the paymentRequest object with all payment attributes
    /// - Parameter encoder: json encoder for the payment
    /// - Throws: ATHMPaymentError if some property is invalid
    func encode(to encoder: Encoder) throws {
        do {
            try hasExceptionableProperties()
            
            var containerRequest = encoder.container(keyedBy: PaymentRequestCodingKeys.self)
            try containerRequest.encodeIfPresent(paymentRequest.timeout, forKey: .timeout)
            
            try paymentRequest.payment.encode(to: encoder)
                        
        } catch let exception {
            throw exception
        }
    }
}

extension AnyPaymentSecureRequestCoder: Exceptionable {
    func hasExceptionableProperties() throws {
        
        let isNormalTimeout = 60...600 ~= paymentRequest.timeout
        
        if !isNormalTimeout {
            throw ATHMPaymentError(message: "Timeout data type value is invalid", source: .request)
        }
    }
}
