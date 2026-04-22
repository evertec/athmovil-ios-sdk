//
//  ATHMPaymentRequestUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class PaymentRequestCoderIT: XCTestCase{
    

    //MARK:- Positive
    
    func testWhenEncodePaymentRequest_GivenTimeoutValue_ThenPaymentRequestEncodeTimeout(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMURLScheme(urlScheme: "test"),
                                  payment: ATHMPayment(total: 1))
        
        try! XCTAssertEncode(encode: request) {
            XCTAssertEqual($0["expiresIn"] as? Double, 120)
        }
    }
    
    func testWhenEncodePaymentRequest_GivenCurrentVersionValue_ThenPaymentRequestEncodeVersion(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMURLScheme(urlScheme: "test"),
                                  payment: ATHMPayment(total: 1))
        
        try! XCTAssertEncode(encode: request) {
            XCTAssertEqual($0["version"] as? String, "3.0")
        }
    }
    
    func testWhenGetCurrentVersion_GivenPaymentRequest_ThenTheVersionIsThree(){
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMURLScheme(urlScheme: "test"),
                                  payment: ATHMPayment(total: 2))
        XCTAssertEqual(request.paymentRequest.version, ATHMVersion.three)
    }
       
    //MARK:- Negative
    
    func testWhenEncodePaymentRequest_GivenInvalidTimeOut_ThenThrowsException(){
        
        let request = getMockData(timeOut: 20,
                                  business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMURLScheme(urlScheme: "test"),
                                  payment: ATHMPayment(total: 2))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Timeout data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    //MARK:- Boundary
    
    func testWhenEncodePaymentRequest_GivenUnexpectedToken_ThenThrowsException(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: ""),
                                  client: ATHMURLScheme(urlScheme: "xamarintest"),
                                  payment: ATHMPayment(total: 2))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The business's token is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenEncodePaymentRequest_GivenUnexpectedURLScheme_ThenThrowsException(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "12313"),
                                  client: ATHMURLScheme(urlScheme: ""),
                                  payment: ATHMPayment(total: 2))
                
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The url scheme is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    
    func testWhenEncodePaymentRequest_GivenUnexpectedPayment_ThenThrowsException(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMURLScheme(urlScheme: "test"),
                                  payment: ATHMPayment(total: -2))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    //MARK:- MockData
    func getMockData(timeOut: Double,
                     business: ATHMBusinessAccount,
                     client: ATHMURLScheme,
                     payment: ATHMPayment) -> AnyPaymentRequestCoder<ATHMPaymentRequest> {
        let paymentRequest = ATHMPaymentRequest(account: business, scheme: client, payment: payment)
        paymentRequest.timeout = timeOut
        return AnyPaymentRequestCoder(paymentRequest: paymentRequest, traceId: UUID().uuidString)
    }
}

