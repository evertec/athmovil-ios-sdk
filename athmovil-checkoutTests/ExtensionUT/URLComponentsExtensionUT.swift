//
//  URLComponentsUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class URLComponentsUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenIsATHMovil_GivenExpectedURL_ThenURLIsNotATHMovil(){
        
        let url = URL(string: "athm://schemeValid?athm_payment_data=test")
        let urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        
        XCTAssertNotNil(urlComponents!.isATHMovil())
    }
    
    //MARK:- Negative
    
    func testWhenIsATHMovil_GivenURLWithUnexpectedPayLoad_ThenTheDataIsNil(){
        
        let url = URL(fileURLWithPath: "urlTest://payment_data=\"\"")
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        XCTAssertNil(urlComponents!.isATHMovil())
    }
    
    //MARK:- Boundary
    
    
    func testWhenIsATHMovil_GivenURLWithoutValue_ThenURLIsNotATHMovil(){
        
        let url = URL(fileURLWithPath: "urlTest://?athm_payment_data=")
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        XCTAssertNil(urlComponents!.isATHMovil())
    }
    
}

