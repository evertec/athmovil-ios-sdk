//
//  ATHMPurchase.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPayment)
final public class ATHMPayment: NSObject {
    
    /// Total of the transaction, it is not calculated in the items
    @objc public let total: NSNumber
    
    /// Purchase subtotal in case the client would not need the subtotal can send as null
    @objc public var subtotal: NSNumber = NSNumber(value: 0.0)
    
    /// Purchase Tax it could be null and the tax would no send to ATH Movil
    @objc public var tax: NSNumber = NSNumber(value: 0.0)
    
    /// Fee amount of the payment
    @objc public var fee: NSNumber = NSNumber(value: 0.0)
    
    /// Net amount of the payment it means total - fee
    @objc public var netAmount: NSNumber = NSNumber(value: 0.0)
    
    /// Purchase items the client could send the list empty and ATH Movil personal will response with the items
    @objc public var items: [ATHMPaymentItem] = [ATHMPaymentItem]()
    
    /// Purchase additional information one it could be null, if the client will send something ATH Movil Personal is going to return the information
    @objc public var metadata1: String = ""
    
    /// Purchase additional information two it could be null, if the client will send something ATH Movil Personal is going to return the information
    @objc public var metadata2: String = ""
    
    /// NEW FLOW
    @objc public var phoneNumber: String = ""
    
    @objc public override var description: String {
        """
        Payment:
            - total: \(total.doubleValue)
            - subtotal: \(subtotal.doubleValue)
            - tax: \(tax.doubleValue)
            - fee: \(fee.doubleValue)
            - netAmount: \(netAmount.doubleValue)
            - metadata1: \(metadata1)
            - metadata2: \(metadata2)
            - Items: \(items.description)
            - phoneNumber: \(phoneNumber)
        """
    }
    
    /// Creates an instance of the representation of the purchase, it is needed the total and the business account and the appclient from comes the request
    /// - Parameter total: Purchases total it has to be greater than zero
    @objc required public init(total: NSNumber) {
        self.total = total
        super.init()
    }
    
    /// Create an instance of the ATHMPayment with a dictionary must have the key total
    /// - Parameter dictionary: The dictionary must have the total key and the others would be empty
    @objc public init(dictionary: NSDictionary) {
        self.total = dictionary[ATHMPayment.CodingKeys.total.rawValue]
        self.tax = dictionary[ATHMPayment.CodingKeys.tax.rawValue]
        self.subtotal = dictionary[ATHMPayment.CodingKeys.subtotal.rawValue]
        self.metadata1 = dictionary[ATHMPayment.CodingKeys.metadata1.rawValue]
        self.metadata2 = dictionary[ATHMPayment.CodingKeys.metadata2.rawValue]
        let itemsDic: [NSDictionary] = dictionary[ATHMPayment.CodingKeys.items.rawValue]
        self.items = itemsDic.map { ATHMPaymentItem(dictionary: $0) }
        // NEW FLOW SECURE
        self.phoneNumber = dictionary[ATHMPayment.CodingKeys.phoneNumber.rawValue]
        super.init()
    }
        
}

extension ATHMPayment: ExpressibleByFloatLiteral {
    
    /// You can use to create a ATHMClientApp like this let instance: ATHMPayment = 20.0
    /// - Parameter value: total of the payment
    public convenience init(floatLiteral value: Float) {
        self.init(total: NSNumber(value: Double(value)))
    }
}

extension ATHMPayment: Model {
    
}
