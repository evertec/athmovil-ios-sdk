//
//  AnyPaymentRequestCoderIT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class AnyPaymentRequestCoderIT: XCTestCase{
    

    //MARK:- Positive
    

    func testWhenEncodeAnyPamentRequest_GivenPaymentBusinessAndClient_ThenEncondeRequestPaymentData() {
        
        let payment = ATHMPayment(total: 2)
        payment.subtotal = 1.0
        payment.tax = 1.0
        payment.metadata1 = "Test metadata1"
        payment.metadata2 = "Test metadata2"
        payment.items = [ATHMPaymentItem(name: "Test", price: 1, quantity: 1)]
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "testToken"),
                                  client: ATHMClientApp(urlScheme: "xamarintest"),
                                  payment: payment)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["total"] as? Double, 2.0)
            XCTAssertEqual($0["subtotal"] as? Double, 1)
            XCTAssertEqual($0["tax"] as? Double, 1)
            XCTAssertEqual($0["metadata1"] as? String, "Test metadata1")
            XCTAssertEqual($0["metadata2"] as? String, "Test metadata2")
            XCTAssertNotNil($0["items"] as? [[String: Any]])
        }))
    }
    
    func testWhenEncodeAnyPamentRequest_GivenPaymentBusinessAndClient_ThenEncondeRequestBusinessData() {
                
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "testToken"),
                                  client: ATHMClientApp(urlScheme: "xamarintest"),
                                  payment: ATHMPayment(total: 2))
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["publicToken"] as? String, "testToken")
        }))
    }
    
    func testWhenEncodeAnyPamentRequest_GivenPaymentBusinessAndClient_ThenEncondeRequestClientAppData() {
                
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "testToken"),
                                  client: ATHMClientApp(urlScheme: "xamarintest"),
                                  payment: ATHMPayment(total: 2))
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["scheme"] as? String, "xamarintest")
        }))
    }
    

    //MARK:- Negative
    
    func testWhenEncodeAnyPamentRequest_GivenPaymentBusinessAndClient_ThenEncondeRequestPaymentDataWithDetultValues() {
        
        let payment = ATHMPayment(total: 2)
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "testToken"),
                                  client: ATHMClientApp(urlScheme: "xamarintest"),
                                  payment: payment)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["total"] as? Double, 2.0)
            XCTAssertEqual($0["subtotal"] as? Double, 0)
            XCTAssertEqual($0["tax"] as? Double, 0)
            XCTAssertEqual($0["metadata1"] as? String, "")
            XCTAssertEqual($0["metadata2"] as? String, "")
            XCTAssertNil($0["items"] as? [String: Any])
        }))
    }
    
    

    //MARK:- Boundary
    
    func testWhenEncodeAnyPaymentRequest_GivenUnexpectedToken_ThenThrowsException(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: ""),
                                  client: ATHMClientApp(urlScheme: "xamarintest"),
                                  payment: ATHMPayment(total: 2))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The business's token is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenEncodeanyPaymentRequest_GivenUnexpectedURLScheme_ThenThrowsException(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "12313"),
                                  client: ATHMClientApp(urlScheme: ""),
                                  payment: ATHMPayment(total: 2))
                
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The url scheme is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    
    func testWhenEncodeAnyPaymentRequest_GivenUnexpectedPayment_ThenThrowsException(){
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMClientApp(urlScheme: "test"),
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
                     client: ATHMClientApp,
                     payment: ATHMPayment) -> AnyPaymentRequestCoder<BusinessAccountCoder, ClientAppCoder, PaymentCoder>{
        
        return AnyPaymentRequestCoder(business: BusinessAccountCoder(business: business),
                                      client: ClientAppCoder(clientAPP: client),
                                      payment: PaymentCoder(payment: payment),
                                      timeout: timeOut)
    }
}

