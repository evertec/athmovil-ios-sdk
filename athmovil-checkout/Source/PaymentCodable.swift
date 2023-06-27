//
//  PaymentCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentCodable: Codable { }

extension ATHMPayment: PaymentCodable {

    enum CodingKeys: String, CodingKey {

        case total,
             subtotal,
             tax,
             fee,
             netAmount,
             metadata1,
             metadata2,
             items,
             //NEW FLOW SECURE
             phoneNumber
    }
}

extension ATHMPayment {
    
    convenience public  init(from decoder: Decoder) throws {

        do {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let total: Double = container.decodeValueDefault(forKey: .total)
            self.init(total: NSNumber(value: total))

            self.subtotal = container.decodeValueDefault(forKey: .subtotal)

            self.tax = container.decodeValueDefault(forKey: .tax)
            
            self.fee = container.decodeValueDefault(forKey: .fee)
            
            self.netAmount = container.decodeValueDefault(forKey: .netAmount)

            self.metadata1 = container.decodeValueDefault(forKey: .metadata1)

            self.metadata2 = container.decodeValueDefault(forKey: .metadata2)

            let itemsDecode = try? container.decodeIfPresent([ATHMPaymentItem].self, forKey: .items) ?? [ATHMPaymentItem]()
            self.items = itemsDecode ?? [ATHMPaymentItem]()
        
            //NEW FLOW SECURITY
            self.phoneNumber = container.decodeValueDefault(forKey: .phoneNumber)
            
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

extension ATHMPayment {
    
    public func encode(to encoder: Encoder) throws {
        
        do {
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(total.doubleValue, forKey: .total)
            try container.encodeIfPresent(subtotal.doubleValue, forKey: .subtotal)
            try container.encodeIfPresent(tax.doubleValue, forKey: .tax)
            try container.encodeIfPresent(metadata1, forKey: .metadata1)
            try container.encodeIfPresent(metadata2, forKey: .metadata2)
            try container.encodeIfPresent(items, forKey: .items)
            //NEW FLOW SECURITY
            try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
            
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

extension ATHMPayment: Exceptionable {
    
    /// Validate the metadata1 and metadata2 that have not invalid characters
    /// - Throws: an exception if one property of ATHMPayment is invalid
    func hasExceptionableProperties() throws {
     
        if total.isUnexpectedAmount {
            throw ATHMPaymentError(message: "Total data type value is invalid",
                                   source: .request)
        }
        
        if tax.doubleValue < 0 || tax.doubleValue.isNaN {
            throw ATHMPaymentError(message: "Tax data type value is invalid",
                                   source: .request)
        }
        
        if metadata1.count > 40 {
            throw ATHMPaymentError(message: "Metadata1 can not be greater than 40 characters",
                                   source: .request)
        }
        
        if metadata2.count > 40 {
            throw ATHMPaymentError(message: "Metadata2 can not be greater than 40 characters",
                                   source: .request)
        }
        
        if subtotal.doubleValue < 0 || subtotal.doubleValue.isNaN {
            throw ATHMPaymentError(message: "Subtotal data type value is invalid",
                                   source: .request)
        }
    }
}
