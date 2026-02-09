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


class PaymentStatusCoderUT: XCTestCase {

    
    //MARK:- Positive
    
    // Cache estática del DateFormatter
    struct FormatterCache {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
            return formatter
        }()
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyDateValue_ThenDecodeDate() {

        let mockDate = Date()
        let mockDateString = FormatterCache.dateFormatter.string(from: mockDate)

        let expectedDic: [String: Any] = [
            "reference": "123",
            "dayliId": 1,
            "status": "completed",
            "date": mockDateString
        ]

        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: expectedDic)
        } catch {
            XCTFail("Error serializando JSON: \(error)")
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(FormatterCache.dateFormatter)

        let response: ATHMPaymentStatus
        do {
            response = try decoder.decode(ATHMPaymentStatus.self, from: jsonData)
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
            return
        }

        XCTAssertEqual(
            mockDateString,
            FormatterCache.dateFormatter.string(from: response.date)
        )
    }


    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueCompleted_ThenDecodeStatusCompleted() {
        
        let expectedDic = getMockData(key: "status", value: "completed")
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.status, .completed)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueCancelled_ThenDecodeStatusCancelled() {
        
        let expectedDic = getMockData(key: "status", value: "cancelled")
        
        do{
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.status, .cancelled)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyStatusValueExpired_ThenDecodeStatusExpired() {
        
        let expectedDic = getMockData(key: "status", value: "expired")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.status, .expired)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyDayliIDValue_ThenDecodeDayliID(){
        
        let expectedDic = getMockData(key: "dailyTransactionID", value: 1)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.dailyTransactionID, 1)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyReferenceNumberValue_ThenDecodeReferenceNumber() {
        
        let expectedDic = getMockData(key: "referenceNumber", value: "Test-12313123")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.referenceNumber, "Test-12313123")
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyVersionValue_ThenDecodeVersion() {
        
        let expectedDic = getMockData(key: "", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.version, .three)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
  
    //MARK:- Negative
    
    func testWhenDecodePaymentStatus_GivenUnexpectedKeyDateValueString_ThenDecodeDateIsTodayDate() {
        
        let expectedDic: [String: Any?] = getMockData(key: "date", value: "")
        let dateConverted = expectedDic.toJSONString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
        let response = try? decoder.decode(ATHMPaymentStatus.self, from: dateConverted!.toData!)
        
        XCTAssertNotNil(response?.date)
    }
    
    func testWhenDecodePaymentStatus_GivenKeyStatusValueEmpty_ThenDecodeStatusAsCancelled() {
        
        let expectedDic = getMockData(key: "status", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.status, .cancelled)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueEmpty_ThenDecodeDayliIDAsZero() {
        
        let expectedDic = getMockData(key: "dailyTransactionID", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.dailyTransactionID, 0)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyReferenceNumberValueEmpty_ThenDecodeReferenceNumberAsEmpty() {
        
        let expectedDic = getMockData(key: "referenceNumber", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.referenceNumber, "")
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
    }
    
    func testWhenDecodePaymentStatus_GivenExpectedKeyVersionValueEmpty_ThenDecodeVersionAsNil()  {
        
        let expectedDic = getMockData(key: "version", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertNil($0?.version)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    
    //MARK:- Boundary
    
    func testWhenDecodePaymentStatus_GivenWithoutKeyDateValueString_ThenDecodeDateIsTodayDate() {
        
        var expectedDic: [String: Any?] = getMockData(key: "date", value: "")
        expectedDic.removeValue(forKey: "date")
        let dateConverted = expectedDic.toJSONString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
        let response = try? decoder.decode(ATHMPaymentStatus.self, from: dateConverted!.toData!)
        
        XCTAssertNotNil(response?.date)
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDateNilValue_ThenDecodeDateIsTodayDate() {
        
        let expectedDic: [String: Any?] = getMockData(key: "date", value: nil)
        let dateConverted = expectedDic.toJSONString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
        let response = try? decoder.decode(ATHMPaymentStatus.self, from: dateConverted!.toData!)
        
        XCTAssertNotNil(response?.date)
    }
    
    func testWhenDecodePaymentStatus_GivenKeyStatusValueNil_ThenDecodeStatusAsCancelled() {
        
        let expectedDic = getMockData(key: "status", value: nil)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.status, .cancelled)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyStatus_ThenDecodeStatusAsCancelled() {
        
        var expectedDic = getMockData(key: "status", value: nil)
        expectedDic.removeValue(forKey: "status")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.status, .cancelled)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyDayliID_ThenDecodeDayliIDAsDefaultValue() {
        
        var expectedDic = getMockData(key: "dailyTransactionID", value: "")
        expectedDic.removeValue(forKey: "dailyTransactionID")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.status, .cancelled)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueEmpty_ThenDecodeDayliIDAsDefaultValue() {
        
        let expectedDic = getMockData(key: "dailyTransactionID", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.dailyTransactionID, 0)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueNegative_ThenDecodeDayliIDAsPositive() {
        
        let expectedDic = getMockData(key: "dailyTransactionID", value: -9)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.dailyTransactionID, 9)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDValueHexadecimal_ThenDecodeDayliIDAsDefaultValue() {
        
        let expectedDic = getMockData(key: "dailyTransactionID", value: "tetst1234")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.dailyTransactionID, 0)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyDayliIDAsString_ThenDecodeDayliIDAsDefaultValue() {
        
        let expectedDic = getMockData(key: "dailyTransactionID", value: "123")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.dailyTransactionID, 0)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyReferenceNumberValueNil_ThenDecodeReferenceNumberAsEmpty() {
        
        let expectedDic = getMockData(key: "referenceNumber", value: nil)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.referenceNumber, "")
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyReferenceNumber_ThenDecodeReferenceNumberAsEmpty() {
        
        var expectedDic = getMockData(key: "referenceNumber", value: nil)
        expectedDic.removeValue(forKey: "referenceNumber")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertEqual($0?.referenceNumber, "")
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenKeyVersionValueNil_ThenDecodeVersionAsNil() {
        
        let expectedDic = getMockData(key: "version", value: nil)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertNil($0?.version)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
        
    }
    
    func testWhenDecodePaymentStatus_GivenDictionaryWithoutKeyVersion_ThenDecodeVersionAsNil() {
        
        var expectedDic = getMockData(key: "version", value: nil)
        expectedDic.removeValue(forKey: "version")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentStatus.self, from: expectedDic) {
                XCTAssertNil($0?.version)
            }
        } catch {
            XCTFail("Error decodificando ATHMPaymentStatus: \(error)")
        }
    }
    
    func testWhenDecodePaymentStatus_GivenUnexpectedData_ThenThrowsAnException(){
        
        let data = "[]".toData
        let jsonDecoder = JSONDecoder()
        
        XCTAssertThrowsError(try jsonDecoder.decode(ATHMPaymentStatus.self, from: data!)) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }
    }
  
    //MARK:- MockData
    
    func getMockData(key: String, value: Any?) -> [String: Any?] {
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

