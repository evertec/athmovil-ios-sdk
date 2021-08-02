//
//  URLComponentsExtensionUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class URLComponentsExtensionUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenIsATHMovil_GivenExpectedURL_ThenURLIsNotATHMovil() {
        
        let url = URL(string: "athm://schemeValid?athm_payment_data=test")!
        
        XCTAssertNotNil(url.responseFromATHM)
    }
    
    //MARK:- Negative
    
    func testWhenIsATHMovil_GivenURLWithUnexpectedPayLoad_ThenTheDataIsNil() {
        
        let url = URL(fileURLWithPath: "urlTest://payment_data=\"\"")
        
        XCTAssertNil(url.responseFromATHM)
    }
    
    //MARK:- Boundary
    
    
    func testWhenIsATHMovil_GivenURLWithoutValue_ThenURLIsNotATHMovil() {
        
        let url = URL(fileURLWithPath: "urlTest://?athm_payment_data=")
        
        XCTAssertNil(url.responseFromATHM)
    }
    
}

