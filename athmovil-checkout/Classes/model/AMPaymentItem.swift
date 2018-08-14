//
//  AMPaymentItem.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

@objc public class AMPaymentItem : NSObject {
    public let desc: String
    public let name: String
    public let price: String
    public var quantity: String
    
    @objc public init(
        desc: String,
        name: String,
        price: String,
        quantity: String) {
        
        self.desc = desc
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

extension AMPaymentItem {
    var toDictionary: [String: Any] {
        return [
            "description": desc,
            "name": name,
            "price": price,
            "quantity": quantity
        ]
    }
}
