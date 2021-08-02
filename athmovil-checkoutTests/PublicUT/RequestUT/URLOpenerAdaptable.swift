//
//  URLOpenerAdaptable.swift
//  athm-checkoutTests
//
//  Created by Leonardo Maldonado on 2/20/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import XCTest
@testable import athmovil_checkout

class URLOpenerAdaptableUT: XCTestCase {

    // MARK:- Positive
    
    func testWhenOpenURL_GivenATHMovilScheme_ThenOpenTheFirstURL() {
        
        let url = URL(string: "athm://")!
        let alernateURL = URL(string: "appstore://")!
        UIApplication.shared.open(url: url,
                                  alternateURL: alernateURL,
                                  options: [:]) { success in
            XCTAssertTrue(success)
        }
    
    }
    
    // MARK:- Negative
    
    func testWhenOpenURL_GivenUnknowURLAndExpectedSecondaryURL_ThenOpenTheAlternateURL() {
        
        let url = URL(string: "zzzff://")!
        let alernateURL = URL(string: "appstore://")!
        UIApplication.shared.open(url: url,
                                  alternateURL: alernateURL,
                                  options: [:]) { success in
            XCTAssertTrue(success)
        }
        
    }
    
    // MARK:- Boundary
    
    func testWhenOpenURL_GivenUnknowURL_ThenCanNotOpenAnyApplication() {
        
        let url = URL(string: "ff://")!
        let alernateURL = URL(string: "appstre://")!
        UIApplication.shared.open(url: url,
                                  alternateURL: alernateURL,
                                  options: [:]) { success in
            XCTAssertFalse(success)
        }
        
    }
}
