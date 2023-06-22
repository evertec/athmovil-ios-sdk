//
//  URLSchemeCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol URLSchemeCodable: Encodable { }

extension ATHMURLScheme: URLSchemeCodable {
    enum CodingKeys: String, CodingKey {
        case scheme
    }
}

extension ATHMURLScheme {
    
    public func encode(to encoder: Encoder) throws {
        
        do {
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(urlScheme, forKey: .scheme)
            
        } catch let exceptionPayment as ATHMPaymentError {
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            throw paymentException
            
        } catch  {
            
            let messageError = "Sorry for the inconvenience. Please try again later."
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            throw paymentException
        }
    }
    
}

extension ATHMURLScheme: Exceptionable {
    
    func hasExceptionableProperties() throws {
        
        if urlScheme.isEmpty {
            throw ATHMPaymentError(message: "The url scheme is required", source: .request)
        }
    }
}
