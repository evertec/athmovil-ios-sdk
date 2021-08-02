//
//  PaymentStatusDecoderDeprecatedUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class PaymentStatusDecoderDeprecatedUT: XCTestCase {
    

    //MARK:- Positive
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueSuccess_ThenCovertToNewStatusCompleted() {

        let expectedDic = getMockData(key: "status", value: "Success")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.status, .completed)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueTimeOut_ThenCovertToNewStatusExpired() {

        let expectedDic = getMockData(key: "status", value: "TimeOut")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.status, .expired)
        }
    }

    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueCanceled_ThenCovertToNewStatusCancelled() {

        let expectedDic = getMockData(key: "status", value: "Canceled")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.status, .cancelled)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyDayliTransactionIdValue_ThenCovertToNewDayliID() {

        let expectedDic = getMockData(key: "dailyTransactionId", value: "#01")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.dailyTransactionID, 1)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyTransactionReferenceValue_ThenCovertToNewRefence() {

        let expectedDic = getMockData(key: "transactionReference", value: "123124312321")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.referenceNumber, "123124312321")
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeys_ThenGetDateForNewVersion(){

        let expectedDic = getMockData(key: "transactionReference", value: "123124312321")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertNotNil($0?.date)
        }
    }

    //MARK:- Negative
    
    func testWhenDecodePaymentStatus_GivenKeyStatusValueEmpty_ThenStatusISCancelledStatus() {

        let expectedDic = getMockData(key: "status", value: "")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.status, .cancelled)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliTransactionIdValueEmpty_ThenDayliIdIsZero() {

        let expectedDic = getMockData(key: "dailyTransactionId", value: "")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.dailyTransactionID, 0)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenKeyTransactionReferenceValueEmpty_ThenTransactionReferenceIsEmpty() {

        let expectedDic = getMockData(key: "transactionReference", value: "")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.referenceNumber, "")
        }
    }
    

    //MARK:- Boundary
    
    func testWhenDecodePaymentStatus_GivenKeyStatusValueNil_ThenDecoderTrhowsAnException() {

        let expectedDic = getMockData(key: "status", value: nil)

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            XCTAssertTrue(error is ATHMPaymentError)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithOutKeyStatus_ThenDecoderTrhowsAnException() {

        var expectedDic = getMockData(key: "status", value: "")
        expectedDic.removeValue(forKey: "status")

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            XCTAssertTrue(error is ATHMPaymentError)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliTransactionIdValueNil_ThenDayliIdIsZero() {

        let expectedDic = getMockData(key: "dailyTransactionId", value: nil)

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.dailyTransactionID, 0)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyDayliTransactionIdValue_ThenDayliIdIsZero() {

        var expectedDic = getMockData(key: "dailyTransactionId", value: "")
        expectedDic.removeValue(forKey: "dailyTransactionId")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.dailyTransactionID, 0)
        }
    }
    
    func testWhenDecodePaymentStatus_GiventKeyDayliTransactionIdValueAsHexadecimal_ThenDayliIdIsZero() {

        var expectedDic = getMockData(key: "dailyTransactionId", value: "Test12Test1")
        expectedDic.removeValue(forKey: "dailyTransactionId")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.dailyTransactionID, 0)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenKeyTransactionReferenceIdValueNil_ThenTransactionReferenceIsEmpty() {

        let expectedDic = getMockData(key: "transactionReference", value: nil)

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.referenceNumber, "")
        }
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyTransactionReferenceIdValueNil_ThenTransactionReferenceIsEmpty() {

        var expectedDic = getMockData(key: "transactionReference", value: nil)
        expectedDic.removeValue(forKey: "transactionReference")

        try! XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
            XCTAssertEqual($0?.referenceNumber, "")
        }
    }
    

    //MARK:- MockData
    
    func getMockData(key: String, value: Any?) -> [String: Any?] {
        
        var dicResponse: [String: Any?]  = ["completed": false,
                                            "status": "Canceled",
                                            "dailyTransactionId": "#01",
                                            "transactionReference": "1000000001",
                                            "total": 2.50,
                                            "subtotal": nil,
                                            "tax": nil,
                                            "metadata1": nil,
                                            "metadata2": nil,
                                            "items": nil
        ]
        
        dicResponse[key] = value
        
        return dicResponse
    }
    
}

