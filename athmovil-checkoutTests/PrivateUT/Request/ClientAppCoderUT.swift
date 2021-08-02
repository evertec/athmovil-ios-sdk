//
//  ClientAppCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class ClientAppCoderUT: XCTestCase {
    
    //MARK:- Positive
    
    
    func testWhenEncodeURLScheme_GivenURLSchemeAsString_ThenEncodeTheURLScheme() {
        
        let scheme: ATHMURLScheme = "xamarintest"
        
        try! XCTAssertEncode(encode: scheme) { (responseDic) in
            XCTAssertEqual(responseDic["scheme"] as? String, "xamarintest")
        }
    
    }
    
    
    //MARK:- Negative
    
    func testWhenEncodeURLScheme_GivenEmptyEmptyURLScheme_ThenEncodeThrowsAnException() {
        
        let scheme: ATHMURLScheme = ""
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: scheme, assert: { _ in
            XCTAssert(false)
        })) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }
    }
    
   
    func testWhenEncodeURLScheme_GivenEmptyEmptyURLScheme_ThenThrowExceptionInRequest() {
        
        let URLScheme = ATHMURLScheme(urlScheme: "")
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: URLScheme, assert: { _ in
            XCTAssert(false)
        })) {
            let exceptionPayment = $0 as? ATHMPaymentError
            XCTAssertEqual(exceptionPayment?.source, .request)
        }
    }
    
    
    func testWhenEncodeURLScheme_GivenEmptyEmptyURLScheme_ThenThrowExceptionWithDescription() {
        
        let URLSchme: ATHMURLScheme = ""
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: URLSchme, assert: { _ in
            XCTAssert(false)
        })) {
            let exceptionPayment = $0 as? ATHMPaymentError
            XCTAssertEqual(exceptionPayment?.failureReason, "The url scheme is required")
        }
        
    }
    
    
    //MARK:- Boundary
    
}

