//
//  ATHMURLScheme.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMURLScheme)
final public class ATHMURLScheme: NSObject {
    
    /// Scheme of your application, it must be a valid scheme configured in your app, avoid use the scheme of the example
    @objc let urlScheme: String
    
    @objc override public var description: String {
        """
        URL Scheme:
            - scheme: \(urlScheme)
        """
    }
    
    /// Init by default, It is a representation of the client application and the business account
    /// - Parameter urlScheme: scheme of your app it is the url that ATH movil will send the response
    @objc required public init(urlScheme: String) {
        self.urlScheme = urlScheme.trimmingCharacters(in: .whitespaces)
        super.init()
    }
    
    /// You can use this constructor to create an object from a dictionary
    /// - Parameter dictionary: This dictionary must containts the key scheme otherwise the property urlscheme is going to be an empty string
    @objc public init(dictionary: NSDictionary) {
        self.urlScheme = dictionary[ATHMURLScheme.CodingKeys.scheme.rawValue]
        super.init()
    }
    
}

extension ATHMURLScheme: ExpressibleByStringLiteral {
    
    /// You can use to create a ATHMClientApp like this let instance: ATHMURLScheme = "test"
    /// - Parameter value: urlScheme
    public convenience init(stringLiteral value: String) {
        self.init(urlScheme: value)
    }
}
