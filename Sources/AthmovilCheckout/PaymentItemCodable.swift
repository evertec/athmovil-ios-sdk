//
//  PaymentItemCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentItemCodable: Codable { }

extension ATHMPaymentItem: PaymentItemCodable {

    enum ItemCodingKeys: String, CodingKey {
        case name,
             quantity,
             price,
             desc,
             metadata,
             description
    }
}

extension ATHMPaymentItem {
    
    public func encode(to encoder: Encoder) throws {
        
        do {
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: ItemCodingKeys.self)
            
            try container.encodeIfPresent(name, forKey: .name)
            try container.encodeIfPresent(price.doubleValue, forKey: .price)
            try container.encodeIfPresent(quantity, forKey: .quantity)
            try container.encodeIfPresent(desc, forKey: .desc)
            try container.encodeIfPresent(desc, forKey: .description)
            try container.encodeIfPresent(metadata, forKey: .metadata)            
        } catch let exceptionPayment as ATHMPaymentError {
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            throw paymentException
            
        } catch {
            
            let messageError = "Sorry for the inconvenience. Please try again later."
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            throw paymentException
        }
    }
}

extension ATHMPaymentItem {
    
    convenience public init(from decoder: Decoder) throws {

        do {

            let container = try decoder.container(keyedBy: ItemCodingKeys.self)
            
            let name: String = container.decodeValueDefault(forKey: .name)
            let price: Double = container.decodeValueDefault(forKey: .price)
            let quantity: Int = container.decodeValueDefault(forKey: .quantity)
            let descScheme: String = container.decodeValueDefault(forKey: .desc)
            let descServer: String = container.decodeValueDefault(forKey: .description)
            let metadataResponse: String = container.decodeValueDefault(forKey: .metadata)
            
            self.init(name: name, price: NSNumber(value: price), quantity: quantity)
            self.desc = descScheme
            self.metadata = metadataResponse
            
            if self.desc.isEmpty && !descServer.isEmpty {
                self.desc = descServer
            }
            
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

extension ATHMPaymentItem: Exceptionable {
    func hasExceptionableProperties() throws {
        
        if price.isUnexpectedAmount {
            throw ATHMPaymentError(message: "Item's price data type value is invalid",
                                   source: .request)
        }

        let sigNumQuantity = quantity.signum()
        if  sigNumQuantity == -1 || sigNumQuantity == 0 {
            throw ATHMPaymentError(message: "Item's quantity data type value is invalid",
                                   source: .request)
        }

        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            throw ATHMPaymentError(message: "Item's name value is required", source: .request)
        }        
    }
}
