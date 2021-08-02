//
//  ATHMPurchaseItem.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentItem)
final public class ATHMPaymentItem: NSObject {
    
    /// Item name as the client request
    @objc public let name: String

    /// Item quantity as the client request, it must be greater than zero
    @objc public let quantity: Int
    
    /// Item price, it must be greater than zero
    @objc public let price: NSNumber
    
    /// Description of the item
    @objc public var desc: String = ""
    
    /// Additional information of the item if the client would send some information ATH Móvil Personal will return this information
    @objc public var metadata: String  = ""
    
    @objc override public var description: String {
        """
        Payment Item:
            - price: \(price.doubleValue)
            - name: \(name)
            - quantity: \(quantity)
            - desc: \(desc)
            - metadata: \(metadata)
        """
    }
    
    /// Creates a representation of the item, this object does not calculate the price, it means it is not setting price * quantity, price is defined by client
    /// - Parameters:
    ///   - name: Item name there is not contraint about the content
    ///   - price: Item price must be greater than zero, the price total of the item
    ///   - quantity: Item description, can not be empty
    @objc required public init(name: String, price: NSNumber, quantity: Int) {
        self.name = name.trimmingCharacters(in: .whitespaces)
        self.price = price
        self.quantity = quantity
        super.init()
    }
    
    /// Create an instance of ATHPaymentItem with a dictionary
    /// - Parameter dictionary: dictionary that must containt the name, price and quantity keys the others are empty
    @objc public init(dictionary: NSDictionary) {
        self.name = dictionary[ItemCodingKeys.name.rawValue]
        self.price = dictionary[ItemCodingKeys.price.rawValue]
        self.quantity = dictionary[ItemCodingKeys.quantity.rawValue]
        self.desc = dictionary[ItemCodingKeys.desc.rawValue]
        self.metadata = dictionary[ItemCodingKeys.metadata.rawValue]
        super.init()
    }
    
}
