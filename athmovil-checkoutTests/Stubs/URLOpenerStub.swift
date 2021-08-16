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
    
    
    /// Opens a scheme with the provided URL
    /// - Parameters:
    ///   - url: url that will be opened
    ///   - alternateURL: alternative URL when the url parameter can not be opened
    ///   - options: options for openning the url
    ///   - completion: closure to call after the URL have been opened
    func open(url: URL,
              alternateURL: URL,
              options: [UIApplication.OpenExternalURLOptionsKey : Any],
              completion: ((Bool) -> Void)?) {
        
        afterOpenWebSite?(url, options)
    }

}
