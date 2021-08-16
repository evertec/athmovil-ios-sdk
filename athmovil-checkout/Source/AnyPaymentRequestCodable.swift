//
//  AnyPaymentRequestCoder.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentRequestCodable: Encodable {
    
    associatedtype URLScheme: URLSchemeCodable
    associatedtype Business: BusinessAccountCodable
    associatedtype Payment: PaymentCodable

    var businessAccount: Business { get }
    var scheme: URLScheme { get }
    var payment: Payment { get }
    var timeout: TimeInterval { get }
    var version: ATHMVersion { get }
}

struct AnyPaymentRequestCoder<P>: Encodable where P: PaymentRequestCodable {

    let paymentRequest: P
    let traceId: String
    
    private enum PaymentRequestCodingKeys: String, CodingKey {
        case timeout = "expiresIn",
             version = "version",
             traceId = "traceId"
    }
    
    /// Encode the paymentRequest object with all payment attributes
    /// - Parameter encoder: json encoder for the payment
    /// - Throws: ATHMPaymentError if some property is invalid
    func encode(to encoder: Encoder) throws {
        
        do {
            
            try hasExceptionableProperties()
            
            var containerRequest = encoder.container(keyedBy: PaymentRequestCodingKeys.self)
            try containerRequest.encodeIfPresent(paymentRequest.timeout, forKey: .timeout)
            try containerRequest.encodeIfPresent(traceId, forKey: .traceId)
            try containerRequest.encodeIfPresent(paymentRequest.version, forKey: .version)
            
            try paymentRequest.businessAccount.encode(to: encoder)
            
            try paymentRequest.scheme.encode(to: encoder)
            
            try paymentRequest.payment.encode(to: encoder)
                        
        } catch let exception {
            throw exception
        }
    }
}

extension AnyPaymentRequestCoder: Exceptionable {
    func hasExceptionableProperties() throws {
        
        let isNormalTimeout = 60...600 ~= paymentRequest.timeout
        
        if !isNormalTimeout {
            throw ATHMPaymentError(message: "Timeout data type value is invalid", source: .request)
        }
    }
}
