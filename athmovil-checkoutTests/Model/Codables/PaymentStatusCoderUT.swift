//
//  PaymentStatusCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class PaymentStatusCoderUT: XCTestCase{

    
    //MARK:- Positive
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyDateValue_ThenDecodeDate(){
        
        let expectedDic: [String: Any?] = self.getMockData(key: "date", value: "2020-06-10 11:17:26.0")
        let dateConverted = expectedDic.toJSONString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
        let response = try? decoder.decode(PaymentStatusCoder.self, from: dateConverted!.toData!)
        let stringDate = dateFormatter.string(from: response?.statusPayment.date ?? Date())
        
        XCTAssertEqual("2020-06-10 11:17:26.0", stringDate)
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueCompleted_ThenDecodeStatusCompleted(){
        
        let expectedDic = self.getMockData(key: "status", value: "completed")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.status, .completed)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueCancelled_ThenDecodeStatusCancelled(){
        
        let expectedDic = self.getMockData(key: "status", value: "cancelled")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.status, .cancelled)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueExpired_ThenDecodeStatusExpired(){
        
        let expectedDic = self.getMockData(key: "status", value: "expired")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.status, .expired)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyDayliIDValue_ThenDecodeDayliID(){
        
        let expectedDic = self.getMockData(key: "dailyTransactionID", value: 1)
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.dailyTransactionID, 1)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyReferenceNumberValue_ThenDecodeReferenceNumber(){
        
        let expectedDic = self.getMockData(key: "referenceNumber", value: "Test-12313123")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.referenceNumber, "Test-12313123")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyVersionValue_ThenDecodeVersion(){
        
        let expectedDic = self.getMockData(key: "", value: "")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.version, .three)
        }
        
    }
    
  
    //MARK:- Negative
    
    func testWhenDecodePaymentStatus_GivenUnexpectedKeyDateValueString_ThenDecodeDateIsTodayDate(){
        
        let expectedDic: [String: Any?] = self.getMockData(key: "date", value: "")
        let dateConverted = expectedDic.toJSONString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
        let response = try? decoder.decode(PaymentStatusCoder.self, from: dateConverted!.toData!)
        
        XCTAssertNotNil(response?.statusPayment.date)
    }
    
    func testWhenDecodePaymentStatus_GivenKeyStatusValueEmpty_ThenDecodeStatusAsCancelled(){
        
        let expectedDic = self.getMockData(key: "status", value: "")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.status, .cancelled)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueEmpty_ThenDecodeDayliIDAsZero(){
        
        let expectedDic = self.getMockData(key: "dailyTransactionID", value: "")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.dailyTransactionID, 0)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyReferenceNumberValueEmpty_ThenDecodeReferenceNumberAsEmpty(){
        
        let expectedDic = self.getMockData(key: "referenceNumber", value: "")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.referenceNumber, "")
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyVersionValueEmpty_ThenDecodeVersionAsNil(){
        
        let expectedDic = self.getMockData(key: "version", value: "")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertNil($0?.statusPayment.version)
        }
        
    }
    
    
    //MARK:- Boundary
    
    func testWhenDecodePaymentStatus_GivenWithoutKeyDateValueString_ThenDecodeDateIsTodayDate(){
        
        var expectedDic: [String: Any?] = self.getMockData(key: "date", value: "")
        expectedDic.removeValue(forKey: "date")
        let dateConverted = expectedDic.toJSONString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
        let response = try? decoder.decode(PaymentStatusCoder.self, from: dateConverted!.toData!)
        
        XCTAssertNotNil(response?.statusPayment.date)
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDateNilValue_ThenDecodeDateIsTodayDate(){
        
        let expectedDic: [String: Any?] = self.getMockData(key: "date", value: nil)
        let dateConverted = expectedDic.toJSONString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
        let response = try? decoder.decode(PaymentStatusCoder.self, from: dateConverted!.toData!)
        
        XCTAssertNotNil(response?.statusPayment.date)
    }
    
    func testWhenDecodePaymentStatus_GivenKeyStatusValueNil_ThenDecodeStatusAsCancelled(){
        
        let expectedDic = self.getMockData(key: "status", value: nil)
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.status, .cancelled)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyStatus_ThenDecodeStatusAsCancelled(){
        
        var expectedDic = self.getMockData(key: "status", value: nil)
        expectedDic.removeValue(forKey: "status")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.status, .cancelled)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyDayliID_ThenDecodeDayliIDAsDefaultValue(){
        
        var expectedDic = self.getMockData(key: "dailyTransactionID", value: "")
        expectedDic.removeValue(forKey: "dailyTransactionID")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.status, .cancelled)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueEmpty_ThenDecodeDayliIDAsDefaultValue(){
        
        let expectedDic = self.getMockData(key: "dailyTransactionID", value: "")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.dailyTransactionID, 0)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueNegative_ThenDecodeDayliIDAsPositive(){
        
        let expectedDic = self.getMockData(key: "dailyTransactionID", value: -9)
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.dailyTransactionID, 9)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueHexadecimal_ThenDecodeDayliIDAsDefaultValue(){
        
        let expectedDic = self.getMockData(key: "dailyTransactionID", value: "tetst1234")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.dailyTransactionID, 0)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDAsString_ThenDecodeDayliIDAsDefaultValue(){
        
        let expectedDic = self.getMockData(key: "dailyTransactionID", value: "123")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.statusPayment.dailyTransactionID, 0)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyReferenceNumberValueNil_ThenDecodeReferenceNumberAsEmpty(){
        
        let expectedDic = self.getMockData(key: "referenceNumber", value: nil)
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.referenceNumber, "")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyReferenceNumber_ThenDecodeReferenceNumberAsEmpty(){
        
        var expectedDic = self.getMockData(key: "referenceNumber", value: nil)
        expectedDic.removeValue(forKey: "referenceNumber")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertEqual($0?.referenceNumber, "")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyVersionValueNil_ThenDecodeVersionAsNil(){
        
        let expectedDic = self.getMockData(key: "version", value: nil)
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertNil($0?.statusPayment.version)
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyVersion_ThenDecodeVersionAsNil(){
        
        var expectedDic = self.getMockData(key: "version", value: nil)
        expectedDic.removeValue(forKey: "version")
        
        try! XCTAssertDecode(codable: PaymentStatusCoder.self, from: expectedDic) {
            XCTAssertNil($0?.statusPayment.version)
        }
    }
    
    func testWhenDecodePaymentStatus_GivenUnexpectedData_ThenThrowsAnException(){
        
        let data = "[]".toData
        let jsonDecoder = JSONDecoder()
        
        XCTAssertThrowsError(try jsonDecoder.decode(PaymentStatusCoder.self, from: data!)) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }
    }
  
    //MARK:- MockData
    
    func getMockData(key: String, value: Any?) -> [String: Any?]{
        var dicResponse: [String: Any?]  = ["version": "3.0",
                                            "referenceNumber": "31241312312",
                                            "date": 0,
                                            "status": "cancelled",
                                            "dailyTransactionID": 1
                                            ]
        
        dicResponse[key] = value
        
        return dicResponse
    }
    
}

