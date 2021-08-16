//
//  PaymentResponseCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/22/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class PaymentResponseCoderIT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenDecodePaymentResponse_GivenCurrentDicationaryResponse_ThenResponseHasClientData() {
        
        let currentDic = getMockData(key: "", value: "").current
        
        try! XCTAssertDecode(codable: PaymentResponseCoder.self, from: currentDic) {
            XCTAssertNotNil($0?.customer)
            XCTAssertEqual($0?.customer.name, "test")
            XCTAssertEqual($0?.customer.email, "test@evertecinc.com")
            XCTAssertEqual($0?.customer.phoneNumber, "7871234567")
        }
    }
    
    func testWhenDecodePaymentResponse_GivenOldDicationaryResponse_ThenResponseHasClientData() {
        
        let currentDic = getMockData(key: "", value: "").deprecated
        
        try! XCTAssertDecode(codable: PaymentResponseCoder.self, from: currentDic) {
            XCTAssertNotNil($0?.customer)
            XCTAssertEqual($0?.customer.name, "")
            XCTAssertEqual($0?.customer.email, "")
            XCTAssertEqual($0?.customer.phoneNumber, "")
        }
    }
    
    func testWhenDecodePaymentResponse_GivenCurrentDicationaryResponse_ThenResponseHasStatusData() {
        
        let currentDic = getMockData(key: "", value: "").current
        
        try! XCTAssertDecode(codable: PaymentResponseCoder.self, from: currentDic) {
            XCTAssertNotNil($0?.status)
            XCTAssertNotNil($0?.status.date)
            XCTAssertEqual($0?.status.status, .completed)
            XCTAssertEqual($0?.status.referenceNumber, "123456789")
            XCTAssertEqual($0?.status.dailyTransactionID, 1)
        }
    }
    
    func testWhenDecodePaymentResponse_GivenOldDicationaryResponse_ThenResponseHasStatusData() {
        
        let currentDic = getMockData(key: "", value: "").deprecated
        
        try! XCTAssertDecode(codable: PaymentResponseCoder.self, from: currentDic) {
            XCTAssertNotNil($0?.status)
            XCTAssertNotNil($0?.status.date)
            XCTAssertEqual($0?.status.status, .cancelled)
            XCTAssertEqual($0?.status.referenceNumber, "1000000001")
            XCTAssertEqual($0?.status.dailyTransactionID, 2)
        }
    }
    
    func testWhenDecodePaymentResponse_GivenCurrentDicationaryResponse_ThenResponseHasPaymenData() {
        
        let currentDic = getMockData(key: "", value: "").current
        
        try! XCTAssertDecode(codable: PaymentResponseCoder.self, from: currentDic) {
            XCTAssertNotNil($0?.payment)
            XCTAssertEqual($0?.payment.total, 1)
            XCTAssertEqual($0?.payment.tax, 1)
            XCTAssertEqual($0?.payment.subtotal, 1)
            XCTAssertEqual($0?.payment.metadata1, "test 1")
            XCTAssertEqual($0?.payment.metadata2, "test 2")
            XCTAssertEqual($0?.payment.items.count, 1)
        }
    }
    
    func testWhenDecodePaymentResponse_GivenOldDicationaryResponse_ThenResponseHasPaymentData() {
        
        let currentDic = getMockData(key: "", value: "").deprecated
        
        try! XCTAssertDecode(codable: PaymentResponseCoder.self, from: currentDic) {
            XCTAssertNotNil($0?.payment)
            XCTAssertEqual($0?.payment.total, 2.5)
            XCTAssertEqual($0?.payment.tax, 2)
            XCTAssertEqual($0?.payment.subtotal, 2)
            XCTAssertEqual($0?.payment.metadata1, "Old 1")
            XCTAssertEqual($0?.payment.metadata2, "Old 2")
            XCTAssertEqual($0?.payment.items.count, 1)
        }
    }
    
    //MARK:- Negative
    
    func testDecodePaymentResponse_GivenUnexpectedResponse_ThenThrowsAnException() {
        
        let data = "[]".toData
        let jsonDecoder = JSONDecoder()
        
        XCTAssertThrowsError(try jsonDecoder.decode(PaymentResponseCoder.self, from: data!)) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }
    }
    
    //MARK:- Boundary
    
    func testWhenDecodePaymetResponse_GivenDictionaryWithoutStatusKey_ThenThrowsAnException() {
        
        var dictionaryStatus = getMockData(key: "", value: "").deprecated
        dictionaryStatus.removeValue(forKey: "status")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentResponseCoder.self, from: dictionaryStatus, assert: { _ in
            XCTAssert(false)
        })) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }
        
    }
    
    //MARK:- MockData
    
    func getMockData(key: String, value: Any?) -> (current: [String: Any?], deprecated:[String: Any?]) {
        
        var currentResponse: [String: Any?] = ["name": "test",
                                               "phoneNumber": "7871234567",
                                               "metadata1": "test 1",
                                               "tax": 1,
                                               "version": "3.0",
                                               "total": 1,
                                               "referenceNumber": "123456789",
                                               "subtotal": 1,
                                               "metadata2": "test 2",
                                               "date": 0,
                                               "items": [["name": "test", "price": 1, "quantity": 2, "desc": "test"]],
                                               "email": "test@evertecinc.com",
                                               "status": "completed",
                                               "dailyTransactionID": 1
        ]
        
        var deprecatedResponse: [String: Any?] = ["completed": false,
                                                  "status": "Canceled",
                                                  "dailyTransactionId": "#02",
                                                  "transactionReference": "1000000001",
                                                  "total": 2.50,
                                                  "subtotal": 2,
                                                  "tax": 2,
                                                  "metadata1": "Old 1",
                                                  "metadata2": "Old 2",
                                                  "items": [["name": "test", "price": 1, "quantity": 2, "desc": "test"]]]
        
        currentResponse[key] = value
        deprecatedResponse[key] = value
        
        return (currentResponse, deprecatedResponse)
    }
    
}



