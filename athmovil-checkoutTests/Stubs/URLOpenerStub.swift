//
//  URLOpenerStub.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

struct URLOpenerStub: URLOpenerAdaptable {
    
    var afterOpenWebSite: ((_ url: URL, _ options:[UIApplication.OpenExternalURLOptionsKey : Any]) -> ())?
    /**
     Opens a scheme with the provided URL
     
      - Parameters:
        - url: url that will be opened
        - completion: called after opening is completed param is true if the scheme was opened successfully param is false if opening failed
     */
    func openWebsite(url: URL, alternateURL: URL,
                     options: [UIApplication.OpenExternalURLOptionsKey : Any],
                     completion: ((Bool) -> Void)?){
        
        self.afterOpenWebSite?(url, options)
    }
}
