//
//  PaymentSecureCodable.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 4/10/22.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentSecureCodable: Codable { }

extension ATHMSecurePayment: PaymentSecureCodable {

    enum CodingKeys: String, CodingKey {

        case phoneNumber,
             ecommerceId,
             scheme,
             publicToken,
             timeout,
             version
    }
}

extension ATHMSecurePayment {
    
    convenience public init(from decoder: Decoder) throws {

        do {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.init()
            self.phoneNumber = container.decodeValueDefault(forKey: .phoneNumber)
            self.ecommerceId = container.decodeValueDefault(forKey: .ecommerceId)
            self.scheme = container.decodeValueDefault(forKey: .scheme)
            self.publicToken = container.decodeValueDefault(forKey: .publicToken)
            self.timeout = container.decodeValueDefault(forKey: .timeout)
            
            try hasExceptionableProperties()

        } catch let exceptionPayment as ATHMPaymentError {
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .response)
            throw paymentException
            
        } catch {
            
            let messageError = "Sorry for the inconvenience. Please try again later."
            let paymentException = ATHMPaymentError(message: messageError,source: .response)
            throw paymentException
        }
    }
}

extension ATHMSecurePayment {
    
    public func encode(to encoder: Encoder) throws {
        
        do {
            //try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
            try container.encodeIfPresent(ecommerceId, forKey: .ecommerceId)
            try container.encodeIfPresent(scheme, forKey: .scheme)
            try container.encodeIfPresent(publicToken, forKey: .publicToken)
            try container.encodeIfPresent(timeout, forKey: .timeout)
            try container.encodeIfPresent(version, forKey: .version)
            
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

extension ATHMSecurePayment: Exceptionable {
    
    /// Validate the metadata1 and metadata2 that have not invalid characters
    /// - Throws: an exception if one property of ATHMPayment is invalid
    func hasExceptionableProperties() throws {
     
        if ecommerceId.count > 0 {
            throw ATHMPaymentError(message: "EcommerceId can not be empty",
                                   source: .request)
        }
    }
}
