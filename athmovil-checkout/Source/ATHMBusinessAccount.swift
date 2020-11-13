//
//  ATHMBusinessAccount.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMBusinessAccount)
final public class ATHMBusinessAccount: NSObject{
    
    ///Identifier of the current business in the application
    @objc let token: String
    
    @objc override public var description: String{
        """
        Business Account:
            - token: \(token)
        """
    }
        
    /**
     init by default, It is a representation of the business account
        - Parameters:
            - token:business token it has to be the current token of the business
     */
    @objc required public init(token: String) {
        self.token = token.trimmingCharacters(in: .whitespaces)
        
        super.init()
        
    }
    
}




