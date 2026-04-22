//
//  ATHMPurchase.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMSecurePayment)
final public class ATHMSecurePayment: NSObject {
    
    /// NEW FLOW
    @objc public var phoneNumber: String = ""
    @objc public var ecommerceId: String = ""
    @objc public var scheme: String = ""
    @objc public var publicToken: String = ""
    @objc public var timeout: TimeInterval = 600.0
    var version: ATHMVersion = .three
    
    @objc public override var description: String {
        """
        Payment:
            - phoneNumber: \(phoneNumber)
            - ecommerceId: \(ecommerceId)
            - scheme: \(scheme)
            - publicToken: \(publicToken)
            - timeout: \(timeout)
            - version: \(version)
        """
    }
    
    /// Creates an instance of the representation of the purchase, it is needed the total and the business account and the appclient from comes the request
    @objc required public override init() {
        super.init()
    }
    
    /// Create an instance of the ATHMSecurePayment with a dictionary must have the key total
    /// - Parameter dictionary: The dictionary must have the total key and the others would be empty
    @objc public init(dictionary: NSDictionary) {
        self.phoneNumber = dictionary[ATHMSecurePayment.CodingKeys.phoneNumber.rawValue]
        self.ecommerceId = dictionary[ATHMSecurePayment.CodingKeys.ecommerceId.rawValue]
        self.scheme = dictionary[ATHMSecurePayment.CodingKeys.scheme.rawValue]
        self.publicToken = dictionary[ATHMSecurePayment.CodingKeys.publicToken.rawValue]
        self.timeout = dictionary[ATHMSecurePayment.CodingKeys.timeout.rawValue]
        super.init()
    }
        
}

extension ATHMSecurePayment: Model {
    
}
