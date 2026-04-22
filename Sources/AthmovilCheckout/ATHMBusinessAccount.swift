//
//  ATHMBusinessAccount.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMBusinessAccount)
final public class ATHMBusinessAccount: NSObject {
    
    /// Identifier of the current business in the application
    @objc var token: String
    var isSimulatedToken: Bool { token.compare("dummy", options: .caseInsensitive) == .orderedSame }
    
    @objc override public var description: String {
        """
        Business Account:
            - token: \(token)
        """
    }
        
    /// init by default, It is a representation of the business account
    /// - Parameter token: business token it has to be the current token of the business
    @objc required public init(token: String) {
        self.token = token.trimmingCharacters(in: .whitespaces)
        super.init()
    }
    
    /// Create an object with a dictinary with the key public token if it is empty or the key does not exist will return set a empty token
    /// - Parameter dictionary: dictionary that must containts the key token
    @objc public init(dictionary: NSDictionary) {
        self.token = dictionary[ATHMBusinessAccount.CodingKeys.publicToken.rawValue]
        super.init()
    }
}

extension ATHMBusinessAccount: ExpressibleByStringLiteral {
    
    /// You can use to create a ATHMBusinessAccount like this let instance: ATHMBusinessAccount = "98da0sdasldkj"
    /// - Parameter value: token
    public convenience init(stringLiteral value: String) {
        self.init(token: value)
    }
}
