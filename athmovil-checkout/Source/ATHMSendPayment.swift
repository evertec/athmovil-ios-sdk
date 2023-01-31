//
//  ATHMSendPayment.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 4/10/22.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMSendPayment)
final public class ATHMSendPayment: NSObject {
    
    /// Total of the transaction, it is not calculated in the items
    @objc public let total: Double
    
    /// Purchase subtotal in case the client would not need the subtotal can send as null
    @objc public var subtotal: Double = 0.0
    
    /// Purchase Tax it could be null and the tax would no send to ATH Movil
    @objc public var tax: Double = 0.0
    
    /// Purchase items the client could send the list empty and ATH Movil personal will response with the items
    @objc public var items: [ATHMPaymentItem] = [ATHMPaymentItem]()
    
    /// Purchase additional information one it could be null, if the client will send something ATH Movil Personal is going to return the information
    @objc public var metadata1: String = ""
    
    /// Purchase additional information two it could be null, if the client will send something ATH Movil Personal is going to return the information
    @objc public var metadata2: String = ""
    
    @objc public var env: String = ""
    
    @objc public var phoneNumber: String = ""
    
    @objc public var publicToken: String = ""
        
    @objc public override var description: String {
        """
        SendPayment):
            - total: \(total)
            - subtotal: \(subtotal)
            - tax: \(tax)
            - metadata1: \(metadata1)
            - metadata2: \(metadata2)
            - items: \(items)
            - env: \(env)
            - phoneNumber: \(phoneNumber)
            - publicToken: \(publicToken)
        """
    }
    
    /// Creates an instance of the representation of the purchase, it is needed the total and the business account and the appclient from comes the request
    /// - Parameter total: Purchases total it has to be greater than zero
    @objc required public init(total: Double) {
        self.total = total
        super.init()
    }
    
    /// Create an instance of the ATHMSendPayment with a dictionary must have the key total
    /// - Parameter dictionary: The dictionary must have the total key and the others would be empty
    @objc public init(dictionary: NSDictionary) {
        self.total = dictionary[ATHMSendPayment.CodingKeys.total.rawValue]
        self.tax = dictionary[ATHMSendPayment.CodingKeys.tax.rawValue]
        self.subtotal = dictionary[ATHMSendPayment.CodingKeys.subtotal.rawValue]
        self.metadata1 = dictionary[ATHMSendPayment.CodingKeys.metadata1.rawValue]
        self.metadata2 = dictionary[ATHMSendPayment.CodingKeys.metadata2.rawValue]
        let itemsDic: [NSDictionary] = dictionary[ATHMSendPayment.CodingKeys.items.rawValue]
        self.items = itemsDic.map { ATHMPaymentItem(dictionary: $0) }
        self.env = dictionary[ATHMSendPayment.CodingKeys.env.rawValue]
        self.phoneNumber = dictionary[ATHMSendPayment.CodingKeys.phoneNumber.rawValue]
        self.publicToken = dictionary[ATHMSendPayment.CodingKeys.publicToken.rawValue]
        super.init()
    }
        
}

extension ATHMSendPayment: Model {
    
}
