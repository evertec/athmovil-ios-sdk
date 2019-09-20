//
//  AMPaymentItem.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

@objcMembers
public class ATHMPaymentItem: NSObject, Codable {
    public let desc: String
    public let name: String
    private var priceValue: Double!
    public var quantity: Int
    public var metadata: String?
    
    @objc public init(desc: String, name: String, priceNumber: NSNumber, quantity: Int, metadata: String? = nil) throws {
        self.desc = desc
        self.name = name
        self.priceValue = priceNumber.doubleValue
        self.quantity = quantity
        self.metadata = metadata
        
        super.init()
        try self.validateForSpecialChars()
    }
    
    private enum CodingKeys : String, CodingKey {
        case desc, name, priceValue = "price", quantity, metadata
    }
}

extension ATHMPaymentItem {
    var toDictionary: [String: Any] {
        return [
            "desc": desc,
            "name": name,
            "price": priceValue ?? 0,
            "quantity": quantity,
            "metadata": metadata ?? ""
        ]
    }
}

extension ATHMPaymentItem {
    public var price: NSNumber {
        get {
            return NSNumber(value: self.priceValue)
        }
        set {
            self.priceValue = newValue.doubleValue
        }
    }
}

extension ATHMPaymentItem {
    var metadataHasSpecialChars: Bool {
        return metadata != nil && metadata!.containsSpecialChars
    }
    
    var descHasSpecialChars: Bool {
        return desc.containsSpecialChars
    }
    
    var nameHasSpecialChars: Bool {
        return name.containsSpecialChars
    }
    
    private func validateForSpecialChars() throws {
        if metadataHasSpecialChars {
            throw AMErrorType.specialCharactersNotAllowed
        }
        
        if descHasSpecialChars {
            throw AMErrorType.specialCharactersNotAllowed
        }
        
        if nameHasSpecialChars {
            throw AMErrorType.specialCharactersNotAllowed
        }
    }
}
