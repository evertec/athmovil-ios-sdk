//
//  ATHMCustomer.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMCustomer)
final public class ATHMCustomer: NSObject {
    
    /// Customer name it means the name  + lastName, it always has a value not matter the payment result
    @objc public let name: String
    
    /// Customer telephone Number, it always has a value not matter the payment result
    @objc public let phoneNumber: String
    
    /// Customer email, it always has a value not matter the payment result
    @objc public let email: String
    
    @objc override public var description: String {
        """
        Customer:
            - name: \(name)
            - phoneNumber: \(phoneNumber)
            - email: \(email)
        """
    }
    
    required init(name: String, phoneNumber: String, email: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
    }
}

extension ATHMCustomer: ExpressibleByStringLiteral {
    
    /// You can use to create a ATHMCustomer like this let instance: ATHMCustomer = "test"
    /// - Parameter value: string to create a customer empty
    public convenience init(stringLiteral value: String) {
        self.init(name: value, phoneNumber: value, email: value)
    }
}
