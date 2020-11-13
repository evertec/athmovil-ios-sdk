//
//  AnyPaymentRequestCoder.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


protocol PaymentRequestCodable: Encodable{
    
    associatedtype Client
    associatedtype Business
    associatedtype Payment
    
    var business: Business { get set }
    var client: Client { get set }
    var payment: Payment { get set }
    var timeout: TimeInterval { get set }
    
}


struct AnyPaymentRequestCoder<B, C, P>: PaymentRequestCodable, Encodable where B: BusinessAccountCodable,
C: ClientAppCodable, P: PaymentCodable{

    ///Business account if the token account it is empty you will received an exception
    var business: B
    
    ///Current application that will send the request to ATH Móvil Personal
    var client: C
    
    ///Purchase representation to send to ATH Movil
    var payment: P
        
    ///Purchase Timeout in ath movil personal
    var timeout: TimeInterval = 60.0
    
    ///Version of the current request
    var version: ATHMVersion
    
    init(business: B, client: C, payment: P, timeout: TimeInterval, version: ATHMVersion = .three) {
        self.business = business
        self.client = client
        self.payment = payment
        self.timeout = timeout
        self.version = version
    }
    
    private enum PaymentRequestCodingKeys: String, CodingKey {
        case timeout = "expiresIn",
             version = "version"
    }
    
    public func encode(to encoder: Encoder) throws{
        
        do{
            
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: PaymentRequestCodingKeys.self)
            
            try self.business.encode(to: encoder)
            
            try self.client.encode(to: encoder)
            
            try self.payment.encode(to: encoder)
            
            try container.encodeIfPresent(abs(timeout), forKey: .timeout)
            
            try container.encodeIfPresent(version, forKey: .version)
            
        }catch let exception{
            throw exception
        }
    }
}


extension AnyPaymentRequestCoder: Exceptionable{
    func hasExceptionableProperties() throws {
        
        let isNormalTimeout = 60...600 ~= timeout
        
        if !isNormalTimeout{
            throw ATHMPaymentError(message: "Timeout data type value is invalid", source: .request)
        }
    }
}
