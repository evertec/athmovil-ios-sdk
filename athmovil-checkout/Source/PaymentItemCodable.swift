//
//  PaymentItemCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


protocol PaymentItemCodable: Codable {


}

struct PaymentItemCoder: PaymentItemCodable {
    
    let item: ATHMPaymentItem
}

fileprivate enum ItemCodingKeys: String,CodingKey {
    case name,
         quantity,
         price,
         desc,
         metadata
}

extension PaymentItemCoder{
    
    func encode(to encoder: Encoder) throws {
        
        do{
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: ItemCodingKeys.self)
            
            try container.encodeIfPresent(self.item.name, forKey: .name)
            try container.encodeIfPresent(self.item.price.doubleValue, forKey: .price)
            try container.encodeIfPresent(self.item.quantity, forKey: .quantity)
            try container.encodeIfPresent(self.item.desc, forKey: .desc)
            try container.encodeIfPresent(self.item.metadata, forKey: .metadata)
            
        }catch let exceptionPayment as ATHMPaymentError{
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            throw paymentException
            
        }catch let exception{
            
            let genericException = exception as NSError
            let messageError = "There was an error while encode PaymentItem Detail: \(genericException.debugDescription)"
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            throw paymentException
        }
    }
}

extension PaymentItemCoder{
    
    init(from decoder: Decoder) throws {

        do{

            let container = try decoder.container(keyedBy: ItemCodingKeys.self)
            
            let name: String = container.decodeValueDefault(forKey: .name)
            let price: Double = container.decodeValueDefault(forKey: .price)
            let quantity: Int = container.decodeValueDefault(forKey: .quantity)
            let desc: String = container.decodeValueDefault(forKey: .desc)
            let metadata: String = container.decodeValueDefault(forKey: .metadata)
            
            self.item = ATHMPaymentItem(name: name, price: NSNumber(value: price), quantity: quantity)
            self.item.desc = desc
            self.item.metadata = metadata
            
            try hasExceptionableProperties()

        }catch let exceptionPayment as ATHMPaymentError{
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .response)
            throw paymentException
            
        }catch let exception{
            
            let genericException = exception as NSError
            let messageError = "There was an error while decoder PaymentItem. Detail: \(genericException.debugDescription)"
            let paymentException = ATHMPaymentError(message: messageError,source: .response)
            throw paymentException
        }
    }
}


extension PaymentItemCoder: Exceptionable{
    
    func hasExceptionableProperties() throws {
        
        if self.item.price.isUnexpectedAmount{
            throw ATHMPaymentError(message: "Item's price data type value is invalid",
                                   source: .request)
        }
        
        let sigNumQuantity = self.item.quantity.signum()
        if  sigNumQuantity == -1 || sigNumQuantity == 0 {
            throw ATHMPaymentError(message: "Item's quantity data type value is invalid",
                                   source: .request)
        }
        
        if !self.item.metadata.isEmpty && self.item.metadata.containsSpecialChars{
            throw ATHMPaymentError(message: "Item's metadata value is invalid", source: .request)
        }
        
        if self.item.name.trimmingCharacters(in: .whitespaces).isEmpty{
            throw ATHMPaymentError(message: "Item's name value is required", source: .request)
        }
        
    }
    
}
