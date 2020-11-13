//
//  ATHMClientApp.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


@objc(ATHMClientApp)
final public class ATHMClientApp: NSObject{
    
    ///scheme of your application, it must be a valid scheme configured in your app, avoid use the scheme of the example
    ///if you use the example scheme the request will launch a exception before send the request to ATH Móvil Personal
    @objc let urlScheme: String
    

    @objc override public var description: String{
        """
        URL Scheme:
            - scheme: \(urlScheme)
        """
    }
    
    /**
     init by default, It is a representation of the client application and the business account
        - Parameters:
            - urlScheme: scheme of your app it is the url that ATH movil will send the response
     */
    @objc required public init(urlScheme: String) {
        self.urlScheme = urlScheme.trimmingCharacters(in: .whitespaces)
        
        super.init()
        
    }
    
}


