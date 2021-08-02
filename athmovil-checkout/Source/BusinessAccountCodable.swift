//
//  BusinessAccountCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol BusinessAccountCodable: Encodable { }
    
extension ATHMBusinessAccount: BusinessAccountCodable {
    enum CodingKeys: String, CodingKey {
        case publicToken
    }
}

extension ATHMBusinessAccount {

    public func encode(to encoder: Encoder) throws {
        
        do {
        
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(token, forKey: .publicToken)
            
        } catch let exceptionPayment as ATHMPaymentError {
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            throw paymentException
            
        } catch let exception {
            
            let genericException = exception as NSError
            let messageError = "There was an error while encode business account. Detail: \(genericException.debugDescription)"
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            throw paymentException
        }
    }
    
}

extension ATHMBusinessAccount: Exceptionable {
    /// Check it the current object has valid properties, it should return a exception if the object is not valid
    /// - Throws: an ATHMPaymentError if the business token is empty
    func hasExceptionableProperties() throws {
     
        if token.isEmpty {
            throw ATHMPaymentError(message: "The business's token is required", source: .request)
        }
    }
}
