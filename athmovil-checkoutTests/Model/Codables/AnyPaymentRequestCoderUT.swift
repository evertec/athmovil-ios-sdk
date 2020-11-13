//
//  AnyPaymentRequestCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class AnyPaymentRequestCoderUT: XCTestCase{
    
    
    //MARK:- Positive
        
    func testWhenEncodeAnyPaymentRequest_GivenTimeoutValue_ThenPaymentRequestEncodeTimeout(){
        
        let request = getMockData(timeOut: 120, business: "test", client: "test", payment: "test")
        
        try! XCTAssertEncode(encode: request) {
            XCTAssertEqual($0["expiresIn"] as? Double, 120)
        }
    }
    
    func testWhenEncodeAnyPaymentRequest_GivenCurrentVersionValue_ThenPaymentRequestEncodeVersion(){
        
        let request = getMockData(timeOut: 120, business: "test", client: "test", payment: "1")
        
        try! XCTAssertEncode(encode: request) {
            XCTAssertEqual($0["version"] as? String, "3.0")
        }
    }
    
    func testWhenGetCurrentVersion_GivenAnyPaymentRequest_ThenTheVersionIsThree(){
        
        let request = getMockData(timeOut: 120, business: "test", client: "test", payment: "test")
        
        XCTAssertEqual(request.version, ATHMVersion.three)
    }
    
    //MARK:- Negative
    
    func testWhenEncodePaymentRequest_GivenInvalidTimeOut_ThenThrowsException(){
        
        let request = getMockData(timeOut: 20, business: "test", client: "test", payment: "1")
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Timeout data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    //MARK:- Boundary
    
    func testWhenEncodeAnyRequest_GivenEncodeException_ThenThrowsAnATHMMovilException(){
        
        let request = AnyPaymentRequestCoder(business: ExceptionCoderMock(),
                                             client: ClientAppCoderMock(clientTest: ""),
                                             payment: PaymentCoderMock(paymentTest: ""),
                                             timeout: 400)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
        })) { error in
            XCTAssert(error is ATHMPaymentError)
        }
    }
    
    
    
    //MARK:- MockData
    
    func getMockData(timeOut: Double,
                     business: String,
                     client: String,
                     payment: String) -> AnyPaymentRequestCoder<BusinessAccountCoderMock, ClientAppCoderMock, PaymentCoderMock>{
        
        return AnyPaymentRequestCoder(business: BusinessAccountCoderMock(businessTest: business),
                                      client: ClientAppCoderMock(clientTest: client),
                                      payment: PaymentCoderMock(paymentTest: payment),
                                      timeout: timeOut)
    }

}
