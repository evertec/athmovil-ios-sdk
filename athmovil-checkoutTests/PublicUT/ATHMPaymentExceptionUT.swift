//
//  ATHMPaymentExceptionUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class ATHMPaymentExceptionUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenInitException_GivenMessageString_ThenExceptionHasFailReason() {
        
        let exception = ATHMPaymentError(message: "Test Error", source: .request)
        
        XCTAssertEqual(exception.failureReason, "Test Error")
    }
    
    func testWhenInitException_GivenSourceException_ThenExceptionHasSource() {
        
        let exception = ATHMPaymentError(message: "Test Error", source: .request)
        
        XCTAssertEqual(exception.source, .request)
    }
    
    func testWhenInitException_GivenRequestSourceException_ThenExceptionHasDescription() {
        
        let exception = ATHMPaymentError(message: "Test Error", source: .request)
        
        XCTAssertEqual(exception.errorDescription, "Error in request")
    }
    
    func testWhenInitException_GivenResponseSourceException_ThenExceptionHasDescription() {
        
        let exception = ATHMPaymentError(message: "Test Error", source: .response)
        
        XCTAssertEqual(exception.errorDescription, "Error in response")
    }
    
    func testWhenInitException_GivenRequestSourceException_ThenIsErrorInRequest() {
        
        let exception = ATHMPaymentError(message: "Test Error", source: .request)
        
        XCTAssertTrue(exception.isRequestError)
    }
    
    func testWhenInitException_GivenResponseSourceException_ThenIsErrorInResponse() {
        
        let exception = ATHMPaymentError(message: "Test Error", source: .response)
        
        XCTAssertFalse(exception.isRequestError)
    }
    
    //MARK:- Negative
    
    //MARK:- Boundary
    
}

