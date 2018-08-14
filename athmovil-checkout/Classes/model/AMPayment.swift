//
//  AMPayment.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

@objc public class AMPayment : NSObject {
    @objc public var referenceId: String
    @objc public var subTotal: String?
    @objc public var tax: String?
    @objc public var total: String
    @objc public var items: [AMPaymentItem]?
    
    @objc public init(
        referenceId: String,
        subTotal: String?,
        tax: String?,
        total: String,
        items: [AMPaymentItem]?) {
        
        self.referenceId = referenceId
        self.subTotal = subTotal
        self.tax = tax
        self.total = total
        self.items = items
    }
}
@objc 
extension AMPayment {
    var toDictionary: [String: Any]? {
        
        guard let apiToken = AMCheckout.shared
            .apiToken else { return nil }
        
        guard let callbackURL = AMCheckout.shared
            .callbackURL else { return nil }
        
        let expiresIn = AMCheckout.shared.timeout
        
        return [
            "businessToken": apiToken,
            "scheme": callbackURL,
            "expiresIn": expiresIn,
            "subtotal": subTotal ?? "",
            "tax": tax ?? "",
            "total": total,
            "cartReferenceId": referenceId,
            "itemsSelectedList": items?.map({ $0.toDictionary }) ?? ""
        ]
    }
}
