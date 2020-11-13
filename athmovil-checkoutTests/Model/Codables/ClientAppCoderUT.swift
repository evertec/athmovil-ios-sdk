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


class ClientAppCoderUT: XCTestCase{
    
    //MARK:- Positive
    
    
    func testWhenEncodeClientApp_GivenURLScheme_ThenEncodeTheURLScheme(){
        
        let appClientDic = ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: "xamarintest"))
        
        try! XCTAssertEncode(encode: appClientDic) { (responseDic) in
            XCTAssertEqual(responseDic["scheme"] as? String, "xamarintest")
        }
    
    }
    
    
    //MARK:- Negative
    
    func testWhenEncodeClientApp_GivenEmptyURLScheme_ThenEncodeThrowsAnException(){
        
        let appClient = ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: ""))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: appClient, assert: { _ in
            XCTAssert(false)
        })) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }
    }
    
   
    func testWhenEncodeBusinessAccount_GivenEmptyToken_ThenThrowExceptionInRequest(){
        
        let appClient = ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: ""))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: appClient, assert: { _ in
            XCTAssert(false)
        })) {
            let exceptionPayment = $0 as? ATHMPaymentError
            XCTAssertEqual(exceptionPayment?.source, .request)
        }
    }
    
    
    func testWhenEncodeBusinessAccount_GivenEmptyToken_ThenExceptionHasADescription(){
        
        let appClient = ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: ""))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: appClient, assert: { _ in
            XCTAssert(false)
        })) {
            let exceptionPayment = $0 as? ATHMPaymentError
            XCTAssertEqual(exceptionPayment?.failureReason, "The url scheme is required")
        }
        
    }
    
    
    //MARK:- Boundary
    
}

