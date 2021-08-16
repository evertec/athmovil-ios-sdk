//
//  AnyPaymentRequestCoderIT.swift
//  athmovil_checkoutIntegrationTests
//
//  Created by Hansy on 12/22/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

/// This integation test is testing the request for Swift, Ionic and Flutter compatibility. The tests that containts dictionary are for Flutter and Ionic
class AnyPaymentRequestCoderIT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenEncodeAnyPamentRequest_GivenStandarPaymentRequest_ThenEncondeRequestPaymentData() {
        
        let payment = ATHMPayment(total: 2)
        payment.subtotal = 1.0
        payment.tax = 1.0
        payment.metadata1 = "Test metadata1"
        payment.metadata2 = "Test metadata2"
        payment.items = [ATHMPaymentItem(name: "Test", price: 1, quantity: 1)]
        
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: "xamarintest",
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
    
    /// Flutter and Ionic compatibility
    func testWhenEncodeAnyPamentRequest_GivenPaymentAsDictionary_ThenEncondeRequestPaymentData() {
        
        let dicPayment: [AnyHashable: Any] = ["total": 2,
                                              "subtotal": 1.0,
                                              "tax": 1.0,
                                              "metadata1": "Test metadata1",
                                              "metadata2": "Test metadata2",
                                              "items": [
                                                [
                                                  "name": "Test",
                                                  "price": 1,
                                                  "quantity": 1
                                                ]
                                              ]
        ]
        
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: "xamarintest",
                                  payment: ATHMPayment(dictionary: NSDictionary(dictionary: dicPayment)))
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["total"] as? Double, 2.0)
            XCTAssertEqual($0["subtotal"] as? Double, 1)
            XCTAssertEqual($0["tax"] as? Double, 1)
            XCTAssertEqual($0["metadata1"] as? String, "Test metadata1")
            XCTAssertEqual($0["metadata2"] as? String, "Test metadata2")
            XCTAssertNotNil($0["items"] as? [[String: Any]])
        }))
    }
    
    func testWhenEncodeAnyPamentRequest_GivenBusinessToken_ThenEncondeRequestBusinessToken() {
        
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["publicToken"] as? String, "testToken")
        }))
    }
    
    /// Flutter and Ionic compatibility
    func testWhenEncodeAnyPamentRequest_GivenBusinessTokenAsDictionary_ThenEncondeRequestBusinessToken() {
        
        let dictionaryRequest = NSDictionary(dictionary: ["publicToken": "testToken"])
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(dictionary: dictionaryRequest),
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["publicToken"] as? String, "testToken")
        }))
    }
    
    func testWhenEncodeAnyPamentRequest_GivenScheme_ThenEncondeRequestHasASchemeData() {
        
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["scheme"] as? String, "xamarintest")
        }))
    }
    
    /// Flutter and Ionic compatibility
    func testWhenEncodeAnyPamentRequest_GivenSchemeAsDictionary_ThenEncondeRequestHasASchemeData() {
        
        let schemeDic = NSDictionary(dictionary: ["scheme": "xamarintest"])
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: ATHMURLScheme(dictionary: schemeDic),
                                  payment: 2.0)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["scheme"] as? String, "xamarintest")
        }))
    }
    
    func testWhenEncodeAnyPamentRequest_GivenTimeout_ThenEncondeRequestEncodeTimeout() {
        
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["expiresIn"] as? Double, 120)
        }))
    }
    
    func testWhenEncodeAnyPamentRequest_GivenVersion_ThenEncondeRequestEncodeVersion() {
        
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["version"] as? String, ATHMVersion.three.rawValue)
        }))
    }
    
    
    //MARK:- Negative
    
    func testWhenEncodeAnyPamentRequest_GivenPaymentRequestWithAllNecesaryProperties_ThenEncondeRequestPaymentDataWithDetultValues() {
                
        let request = getMockData(timeOut: 120,
                                  business: "testToken",
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["total"] as? Double, 2.0)
            XCTAssertEqual($0["subtotal"] as? Double, 0)
            XCTAssertEqual($0["tax"] as? Double, 0)
            XCTAssertEqual($0["metadata1"] as? String, "")
            XCTAssertEqual($0["metadata2"] as? String, "")
            XCTAssertEqual($0["publicToken"] as? String, "testToken")
            XCTAssertNil($0["items"] as? [String: Any])
        }))
    }
    
    func testWhenEncodeAnyPamentRequest_GivenPaymentRequestAsDictionaryWithAllNecesaryProperties_ThenEncondeRequestPaymentDataWithDetultValues() {
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(dictionary: NSDictionary(dictionary: ["publicToken": "Test"])),
                                  scheme: ATHMURLScheme(dictionary: NSDictionary(dictionary: ["scheme": "xamarintest"])),
                                  payment: ATHMPayment(dictionary: NSDictionary(dictionary: ["total": 2.0])))
        
        XCTAssertNoThrow(try XCTAssertEncode(encode: request, assert: {
            XCTAssertEqual($0["total"] as? Double, 2.0)
            XCTAssertEqual($0["subtotal"] as? Double, 0)
            XCTAssertEqual($0["tax"] as? Double, 0)
            XCTAssertEqual($0["metadata1"] as? String, "")
            XCTAssertEqual($0["metadata2"] as? String, "")
            XCTAssertEqual($0["publicToken"] as? String, "Test")
            XCTAssertNil($0["items"] as? [String: Any])
        }))
    }
    
    
    //MARK:- Boundary
    
    func testWhenEncodeAnyPaymentRequest_GivenUnexpectedToken_ThenThrowsException() {
        
        let request = getMockData(timeOut: 120,
                                  business: "",
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The business's token is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenEncodeAnyPaymentRequest_GivenUnexpectedTokenAsDictionary_ThenThrowsException() {
        
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(dictionary: ["publicToken": ""]),
                                  scheme: "xamarintest",
                                  payment: 2.0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The business's token is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenEncodeanyPaymentRequest_GivenUnexpectedURLScheme_ThenThrowsException() {
        
        let request = getMockData(timeOut: 120,
                                  business: "12313",
                                  scheme: "",
                                  payment: 2.0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The url scheme is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodeanyPaymentRequest_GivenUnexpectedURLSchemeAsDictionary_ThenThrowsException() {
        
        let request = getMockData(timeOut: 120,
                                  business: "12313",
                                  scheme: ATHMURLScheme(dictionary: NSDictionary(dictionary: ["urlScheme": ""])),
                                  payment: 2.0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The url scheme is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodeAnyPaymentRequest_GivenUnexpectedPayment_ThenThrowsException() {
        
        let request = getMockData(timeOut: 120,
                                  business: "test",
                                  scheme: "test",
                                  payment: -2.0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodeAnyPaymentRequest_GivenUnexpectedPaymentAsDictionary_ThenThrowsException() {
        
        let request = getMockData(timeOut: 120,
                                  business: "test",
                                  scheme: "test",
                                  payment: ATHMPayment(dictionary: NSDictionary(dictionary: ["total": -2.0])))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodeAnyPaymentRequest_GivenUnexpectedEmptyDictionary_ThenThrowsException() {
        
        let dicEmpty = NSDictionary(dictionary: [AnyHashable : Any]())
        let request = getMockData(timeOut: 120,
                                  business: ATHMBusinessAccount(dictionary: dicEmpty),
                                  scheme: ATHMURLScheme(dictionary: dicEmpty),
                                  payment: ATHMPayment(dictionary: dicEmpty))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    //MARK:- MockData
    
    func getMockData(timeOut: Double,
                     business: ATHMBusinessAccount,
                     scheme: ATHMURLScheme,
                     payment: ATHMPayment) -> AnyPaymentRequestCoder<ATHMPaymentRequest> {
        
        let paymentRequest = ATHMPaymentRequest(account: business, scheme: scheme, payment: payment)
        paymentRequest.timeout = timeOut
        
        return AnyPaymentRequestCoder(paymentRequest: paymentRequest, traceId: "Teste")
    }
}

