//
//  PaymentCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class PaymentCoderUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenDecodePayment_GivenExpectedTotal_ThenDecodeTotal() {
        
        let paymentDic = getMockData(key: "total", value: 5.0)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.total, 5.0)
        }
    }
    
    func testWhenEncodePayment_GivenExpectedTotal_ThenEncodeTotalKey() {
        
        let payment = ATHMPayment(total: 20)
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["total"] as? Double, 20)
        }
    }
    
    func testWhenDecodePayment_GivenExpectedSubTotal_ThenDecodeSubTotal() {
        
        let paymentDic = getMockData(key: "subtotal", value: 6.0)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.subtotal, 6.0)
        }
    }
    
    func testWhenEncodePayment_GivenExpectedSubTotal_ThenEncodeSubtotalKey() {
        
        let payment = ATHMPayment(total: 3)
        payment.subtotal = 2
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["subtotal"] as? Double, 2)
        }
        
    }
    
    func testWhenDecodePayment_GivenExpectedTax_ThenDecodeTax() {
        
        let paymentDic = getMockData(key: "tax", value: 3.0)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.tax, 3.0)
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedTax_ThenEncodeTaxKey(){
        
        let payment = ATHMPayment(total: 3)
        payment.tax = 9
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["tax"] as? Double, 9)
        }
        
    }
    
    func testWhenDecodePayment_GivenExpectedMetadata1_ThenDecodeMetadata1() {
        
        let paymentDic = getMockData(key: "metadata1", value: "This is valid metadata 1")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata1, "This is valid metadata 1")
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedMetadata1_ThenEncodeMetadata1Key() {
        
        let payment = ATHMPayment(total: 3)
        payment.metadata1 = "This is valid metadata 1"
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["metadata1"] as? String, "This is valid metadata 1")
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedLenghtMetadata1_ThenEncodeMetadata1Key() {
        
        let payment = ATHMPayment(total: 3)
        payment.metadata1 = String(repeating: "A", count: 40)
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["metadata1"] as? String, String(repeating: "A", count: 40))
        }
        
    }
    
    
    func testWhenDecodePayment_GivenExpectedMetadata2_ThenDecodeMetadata2() {
        
        let paymentDic = getMockData(key: "metadata2", value: "This is valid metadata 2")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata2, "This is valid metadata 2")
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedMetadata2_ThenEncodeMetadata2Key() {
        
        let payment = ATHMPayment(total: 3)
        payment.metadata2 = "This is valid metadata 2"
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["metadata2"] as? String, "This is valid metadata 2")
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedLenghtMetadata2_ThenEncodeMetadata2Key() {
        
        let payment = ATHMPayment(total: 3)
        payment.metadata2 = String(repeating: "A", count: 40)
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["metadata2"] as? String, String(repeating: "A", count: 40))
        }
        
    }
    
    func testWhenDecodePayment_GivenExpectedItems_ThenDecodePaymentItems() {
        
        let itemDic = [["name": "test 1", "quantity": 1, "price": 2, "desc": "test 1"],
                        ["name": "test 2", "quantity": 1, "price": 2, "desc": "test 2"]]
        let paymentDic = getMockData(key: "items", value: itemDic)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.items.count, 2)
        }
        
    }
    
    func testWhenEncodePayment_GivenTwoExpectedItems_ThenEncodeItemsKey() {
        
        let payment = ATHMPayment(total: 3)
        payment.items = [ATHMPaymentItem(name: "Test 1", price: 1, quantity: 1),
                        ATHMPaymentItem(name: "Test 2", price: 2, quantity: 2)]
        
        try! XCTAssertEncode(encode: payment) {
            let items = $0["items"] as? [Any]
            XCTAssertEqual(items?.count, 2)
        }
    }
    
    //MARK:- Negative
    
    func testWhenDecodePayment_GivenZeroTotal_ThenThrowsAnException() {
        
        let paymentDic = getMockData(key: "total", value: 0)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { (error) in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
    }
    
    func testWhenEncodePayment_GivenZeroTotal_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: 0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenZeroSubTotal_ThenEncodeSubtotalAsZero() {
        
        let paymentData = getMockData(key: "subtotal", value: 0)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentData) {
            XCTAssertEqual($0?.subtotal, 0)
        }
    }
    
    func testWhenEncodePayment_GivenZeroSubTotal_ThenEncodeSubtotalAsZero(){
        
        let payment = ATHMPayment(total: 1)
        payment.subtotal = 0
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["subtotal"] as? Double, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenZeroTax_ThenEncodeTaxAsZero() {
        
        let paymentData = getMockData(key: "tax", value: 0)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentData) {
            XCTAssertEqual($0?.tax, 0)
        }
    }
    
    func testWhenEncodePayment_GivenZeroTax_ThenEncodeTaxAsZero() {
        
        let payment = ATHMPayment(total: 1)
        payment.tax = 0
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["tax"] as? Double, 0)
        }
        
    }
    
    func testWhenDecoderPayment_GivenMetadata1Key_ThenDecodeMetadata1AsEmptyString() {
        
        let paymentDic = getMockData(key: "metadata1", value: "")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata1, "")
        }
    }
    
    func testWhenEncodePayment_GivenEmptyMetadata1_ThenEncoderMetadata1AsEmptyString() {
        
        let payment = ATHMPayment(total: 10)
        payment.metadata1 = ""
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["metadata1"] as? String, "")
        }
    }
    
    func testWhenEncodePayment_GivenMetadata1GreaterThan40Characters_TheEncodeThrowsAnException() {
        let payment = ATHMPayment(total: 10)
        payment.metadata1 = String(repeating: "A", count: 41)
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in}), "") { error in
            if let paymentError = error as? ATHMPaymentError {
                XCTAssertEqual(paymentError.failureReason, "Metadata1 can not be greater than 40 characters")
                return
            }
            XCTAssert(false)
        }
    }

    
    func testWhenDecoderPayment_GivenMetadata2Key_ThenDecodeMetadata2AsEmptyString() {
        
        let paymentDic = getMockData(key: "metadata2", value: "")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata2, "")
        }
    }
    
    func testWhenEncodePayment_GivenEmptyMetadata2_ThenEncoderMetadata2AsEmptyString() {
        
        let payment = ATHMPayment(total: 10)
        payment.metadata2 = ""
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertEqual($0["metadata2"] as? String, "")
        }
    }
    
    func testWhenEncodePayment_GivenMetadata2GreaterThan40Characters_TheEncodeThrowsAnException() {
        let payment = ATHMPayment(total: 10)
        payment.metadata2 = String(repeating: "A", count: 41)
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in}), "") { error in
            if let paymentError = error as? ATHMPaymentError {
                XCTAssertEqual(paymentError.failureReason, "Metadata2 can not be greater than 40 characters")
                return
            }
            XCTAssert(false)
        }
    }

    
    func testWhenDecodePayment_GivenEmptyItems_ThenDecodePaymentAsEmptyArray() {
        
        let items = [[String: Any]]()
        let paymentDic = getMockData(key: "items", value: items)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.items.count, 0)
        }
        
    }
    
    func testWhenEncodePayment_GivenEmptyItems_ThenEncodeItemsKeyAsEmptyList() {
        
        let payment = ATHMPayment(total: 3)
        payment.items = [ATHMPaymentItem]()
        
        try! XCTAssertEncode(encode: payment) {
            let items = $0["items"] as? [Any]
            XCTAssertEqual(items?.count, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenUnexpectedDictionary_ThenThrowsAnException() {
        
        var paymentDic = getMockData(key: "", value: 0)
        paymentDic.removeAll()
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { (error) in
            XCTAssert(error is ATHMPaymentError)
        }
    }
    
    //MARK:- Boundary
    
    func testWhenDecodePayment_GivenNegativeTotal_ThenThrowsAnException() {
        
        let paymentDic = getMockData(key: "total", value: -5)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
        
    }
    
    func testWhenDecodePayment_GivenTotalLessThanOne_ThenThrowsAnException() {
        
        let paymentDic = getMockData(key: "total", value: 0.5)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
        
    }
    
    func testWhenDecodePayment_GivenTotalAsHexadecimalKey_ThenThrowsAnException() {
        
        let paymentDic = getMockData(key: "total", value: "total123")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
    }
    
    func testWhenDecodePayment_GivenTotalAsStringKey_ThenThrowsAnException() {
        
        let paymentDic = getMockData(key: "total", value: "1234")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
    }
    
    func testWhenDecodePayment_GivenDictionaryWithoutKeyTotal_ThenThrowsAnException() {
        
        var paymentDic = getMockData(key: "total", value: 2)
        paymentDic.removeValue(forKey: "total")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenEncodePayment_GivenNegativeTotal_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: -120)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodePayment_GivenTotalLessThanOne_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: 0.5)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodePayment_GivenTotalAsNan_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: NSNumber(value: Double.nan))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenNegativeSubTotal_ThenThrowsAnException() {
        
        let paymentDic = getMockData(key: "subtotal", value: -5)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Subtotal data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenDecodePayment_GivenNilSubTotalKey_ThenDecodeSubTotalAsDefault() {
        
        let paymentData = getMockData(key: "subtotal", value: nil)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentData) {
            XCTAssertEqual($0?.subtotal, 0)
        }
    
    }
    
    func testWhenDecodePayment_GivenSubTotalAsStringKey_ThenSubtotalIsDefaultValue() {
        
        let paymentDic = getMockData(key: "subtotal", value: "1234")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.subtotal, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenSubTotalAsHasHexadeicmalKey_ThenSubtotalIsDefaultValue() {
        
        let paymentDic = getMockData(key: "subtotal", value: "subtotal1234")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.subtotal, 0)
        }
    }
    
    func testWhenEncodePayment_GivenNegativeSubTotal_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: 1)
        payment.subtotal = -102
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Subtotal data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodePayment_GivenSubTotalAsNan_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: 1)
        payment.subtotal = NSNumber(value: Double.nan)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Subtotal data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenDictionaryWithoutKeySubTotal_ThenSubTotalHasDefaultValue() {
        
        var paymentDic = getMockData(key: "subtotal", value: "1234")
        paymentDic.removeValue(forKey: "subtotal")

        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.subtotal, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenNegativeTax_ThenThrowsAnException() {
        
        let paymentDic = getMockData(key: "tax", value: -1)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Tax data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenDecodePayment_GivenNilTaxKey_ThenDecodeTaxAsDefault() {
        
        let paymentData = getMockData(key: "tax", value: nil)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentData) {
            XCTAssertEqual($0?.tax, 0)
        }
    
    }
    
    func testWhenDecodePayment_GivenTaxAsStringKey_ThenTaxIsDefaultValue() {
        
        let paymentDic = getMockData(key: "tax", value: "1234")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.tax, 0)
        }
        
    }
    
    func testWhenEncodePayment_GivenNegativeTax_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: 1)
        payment.tax = -102
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Tax data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodePayment_GivenTaxAsNan_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: 1)
        payment.tax = NSNumber(value: Double.nan)
    
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Tax data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenDictionaryWithoutKeyTax_ThenTaxHasDefaultValue() {
        
        var paymentDic = getMockData(key: "tax", value: 1)
        paymentDic.removeValue(forKey: "tax")

        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.tax, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenTaxAsHasHexadecimalKey_ThenTaxIsDefaultValue() {
        
        let paymentDic = getMockData(key: "tax", value: "tax1234")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.tax, 0)
        }
    }
    
    func testWhenDecoderPayment_GivenNilMetadata1Key_ThenDecodeMetadata1AsEmptyString() {
        
        let paymentDic = getMockData(key: "metadata1", value: nil)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata1, "")
        }
    }
    
    func testWhenEncodePayment_GivenEspecialCharactesInMetadata1_ThenCanEncodeTheMetadata1Property() {
        
        let payment = ATHMPayment(total: 1)
        payment.metadata1 = "Request:?@|_'\"{}^–!@#%$?:[]"
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertNotNil($0["metadata1"] as? String)
        }
    }
    
    func testWhenDecodePayment_GivenEspecialCharactersInMetadata1_ThenCanDecodeTheMetadata1Property() {
        
        let paymentDic = getMockData(key: "metadata1", value: "Response:?@|_'\"{}^–!@#%$?:[]")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata1,"Response:?@|_'\"{}^–!@#%$?:[]")
        }
    }
    
    func testWhenDecoderPayment_GivenDictionaryWithoutMetadata1Key_ThenDecodeMetadata1AsEmptyString() {
        
        var paymentDic = getMockData(key: "metadata1", value: nil)
        paymentDic.removeValue(forKey: "metadata1")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata1, "")
        }
    }
    
    func testWhenDecoderPayment_GivenNilMetadata2Key_ThenDecodeMetadata2AsEmptyString() {
        
        let paymentDic = getMockData(key: "metadata2", value: nil)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata2, "")
        }
    }
        
    func testWhenEncodePayment_GivenEspecialCharactesInMetadata2_ThenCanEncodeMetadata2Property() {
        
        let payment = ATHMPayment(total: 1)
        payment.metadata2 = "Request:?@|_'\"{}^–!@#%$?:[]"
        
        try! XCTAssertEncode(encode: payment) {
            XCTAssertNotNil($0["metadata2"] as? String)
        }
    }
    
    func testWhenDecodePayment_GivenEspecialCharactersInMetadata2_ThenCanDecodeMetadata2Property() {
        
        let paymentDic = getMockData(key: "metadata2", value: "Response:?@|_'\"{}^–!@#%$?:[]")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata2,"Response:?@|_'\"{}^–!@#%$?:[]")
        }
    }
    
    func testWhenDecoderPayment_GivenDictionaryWithoutMetadata2Key_ThenDecodeMetadata2AsEmptyString() {
        
        var paymentDic = getMockData(key: "metadata2", value: nil)
        paymentDic.removeValue(forKey: "metadata2")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.metadata2, "")
        }
    }
    
    func testWhenDecodePayment_GivenItemsValueKeyAsNil_ThenDecodePaymentAsEmptyArray() {
        
        let paymentDic = getMockData(key: "items", value: nil)
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.items.count, 0)
        }
    }
    
    func testWhenDecodePayment_GivenItemsKeyAsNil_ThenDecodePaymentAsEmptyArray() {
        
        var paymentDic = getMockData(key: "items", value: nil)
        paymentDic.removeValue(forKey: "items")
        
        try! XCTAssertDecode(codable: ATHMPayment.self, from: paymentDic) {
            XCTAssertEqual($0?.items.count, 0)
        }
    }
    
    func testWhenEncodePayment_GivenInvalidItem_ThenThrowsAnException() {
        
        let payment = ATHMPayment(total: 1)
        payment.items = [ATHMPaymentItem(name: "Exception", price: -2, quantity: 0)]
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    

    //MARK:- MockData
    
    func getMockData(key: String, value: Any?) -> [String: Any?] {
        
        var dic: [String: Any] = ["total": 20.0,
                                  "subtotal": 1,
                                  "tax": "2",
                                  "metadata1": "This is metadata 1",
                                  "metadata2": "This is metadata 2",
                                  "items":""]
        
        dic[key] = value
        
        return dic
    }
}

