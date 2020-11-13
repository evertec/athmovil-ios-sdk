//
//  PaymentCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


protocol PaymentCodable: Codable {
    
}

struct PaymentCoder: PaymentCodable {
    
    let payment: ATHMPayment
    
}


fileprivate enum CodingKeys: String, CodingKey{
    
    case total,
        subtotal,
        tax,
        fee,
        netAmount,
        metadata1,
        metadata2,
        items
}

extension PaymentCoder{
    
    init(from decoder: Decoder) throws{

        do {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            let total: Double = container.decodeValueDefault(forKey: .total)
            self.payment = ATHMPayment(total: NSNumber(value: total))

            let subtotal: Double = container.decodeValueDefault(forKey: .subtotal)
            self.payment.subtotal = NSNumber(value: subtotal)

            let tax: Double = container.decodeValueDefault(forKey: .tax)
            self.payment.tax = NSNumber(value: tax)
            
            let fee: Double = container.decodeValueDefault(forKey: .fee)
            self.payment.fee = NSNumber(value: fee)
            
            let netAmount: Double = container.decodeValueDefault(forKey: .netAmount)
            self.payment.netAmount = NSNumber(value: netAmount)

            self.payment.metadata1 = container.decodeValueDefault(forKey: .metadata1)

            self.payment.metadata2 = container.decodeValueDefault(forKey: .metadata2)

            let itemsDecode = try? container.decodeIfPresent([PaymentItemCoder].self, forKey: .items) ?? [PaymentItemCoder]()
            
            let itemsPayment = itemsDecode?.map{ $0.item }
            payment.items = itemsPayment ?? [ATHMPaymentItem]()
        
            try hasExceptionableProperties()

        }catch let exceptionPayment as ATHMPaymentError{
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .response)
            throw paymentException
            
        }catch let exception{
            
            let genericException = exception as NSError
            let messageError = "There was an error while decode payment. Detail: \(genericException.debugDescription)"
            let paymentException = ATHMPaymentError(message: messageError,source: .response)
            throw paymentException
        }
    }
}

extension PaymentCoder{
    
    func encode(to encoder: Encoder) throws{
        
        do{
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.payment.total.doubleValue, forKey: .total)
            try container.encodeIfPresent(self.payment.subtotal.doubleValue, forKey: .subtotal)
            try container.encodeIfPresent(self.payment.tax.doubleValue, forKey: .tax)
            try container.encodeIfPresent(self.payment.metadata1, forKey: .metadata1)
            try container.encodeIfPresent(self.payment.metadata2, forKey: .metadata2)
            
            let itemsCoder = self.payment.items.map{ PaymentItemCoder(item: $0) }
            try container.encodeIfPresent(itemsCoder, forKey: .items)
            
        }catch let exceptionPayment as ATHMPaymentError{
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            throw paymentException
            
        }catch let exception{
            
            let genericException = exception as NSError
            let messageError = "There was an error while encode payment Detail: \(genericException.localizedDescription)"
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            throw paymentException
        }

    }
}

extension PaymentCoder: Exceptionable{
    /**
     Validate the metadata1 and metadata2 that have not invalid characters
     */
    func hasExceptionableProperties() throws {
     
        if self.payment.total.isUnexpectedAmount{
            throw ATHMPaymentError(message: "Total data type value is invalid",
                                   source: .request)
        }
        
        if self.payment.tax.doubleValue < 0 || self.payment.tax.doubleValue.isNaN{
            throw ATHMPaymentError(message: "Tax data type value is invalid",
                                   source: .request)
        }
        
        if self.payment.subtotal.doubleValue < 0 || self.payment.subtotal.doubleValue.isNaN{
            throw ATHMPaymentError(message: "Subtotal data type value is invalid",
                                   source: .request)
        }
        
        if !self.payment.metadata1.isEmpty && self.payment.metadata1.containsSpecialChars{
            throw ATHMPaymentError(message: "The metadata1 data type value is invalid", source: .request)
        }
        
        if !self.payment.metadata2.isEmpty && self.payment.metadata2.containsSpecialChars{
            throw ATHMPaymentError(message: "The metadata2 data type value is invalid", source: .request)
        }
    }
}
