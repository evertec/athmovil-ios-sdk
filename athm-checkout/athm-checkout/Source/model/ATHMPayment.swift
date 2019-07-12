//
//  AMPayment.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

@objcMembers
public class ATHMPayment: NSObject {
    public var total: NSNumber
    public var subtotal: NSNumber?
    public var tax: NSNumber?
    public var metadata1: String?
    public var metadata2: String?
    public var items: [ATHMPaymentItem]?
    
    @objc public init(
        total: NSNumber,
        subtotal: NSNumber? = nil,
        tax: NSNumber? = nil,
        metadata1: String? = nil,
        metadata2: String? = nil,
        items: [ATHMPaymentItem]? = nil) throws {
        
        self.total = total
        self.subtotal = subtotal
        self.tax = tax
        self.metadata1 = metadata1
        self.metadata2 = metadata2
        self.items = items
        
        super.init()
        try self.validateForSpecialChars()
    }
}

@objc extension ATHMPayment {
    public var toDictionary: [String: Any]? {
        
        guard let publicToken = ATHMCheckout.shared.publicToken else { return nil }
        
        guard let callbackURL = ATHMCheckout.shared.callbackURL else { return nil }
        
        let expiresIn = ATHMCheckout.shared.timeout
        
        return [
            "publicToken": publicToken,
            "scheme": callbackURL,
            "expiresIn": expiresIn,
            "total": total,
            "subtotal": subtotal ?? "",
            "tax": tax ?? "",
            "metadata1": metadata1 ?? "",
            "metadata2": metadata2 ?? "",
            "items": items?.map({ $0.toDictionary }) ?? ""
        ]
    }
}

extension ATHMPayment {
    var metadata1HasSpecialChars: Bool {
        return metadata1 != nil && metadata1!.containsSpecialChars
    }
    
    var metadata2HasSpecialChars: Bool {
        return metadata2 != nil && metadata2!.containsSpecialChars
    }
    
    private func validateForSpecialChars() throws {
        if metadata1HasSpecialChars {
            throw AMErrorType.specialCharactersNotAllowed
        }
        
        if metadata2HasSpecialChars {
            throw AMErrorType.specialCharactersNotAllowed
        }
    }
}

extension String {
    var containsSpecialChars: Bool {
        let pattern = ".*[^\\sA-Za-z0-9].*"
        let regex = NSRegularExpression(pattern)
        return regex.matches(self)
    }
}


