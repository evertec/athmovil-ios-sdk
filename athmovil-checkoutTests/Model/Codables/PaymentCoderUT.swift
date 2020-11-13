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
    
    func testWhenDecodePayment_GivenExpectedTotal_ThenDecodeTotal(){
        
        let paymentDic = self.getMockData(key: "total", value: 5.0)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.total, 5.0)
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedTotal_ThenEncodeTotalKey(){
        
        let payment = ATHMPayment(total: 20)
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            XCTAssertEqual($0["total"] as? Double, 20)
        }
    }
    
    func testWhenDecodePayment_GivenExpectedSubTotal_ThenDecodeSubTotal(){
        
        let paymentDic = self.getMockData(key: "subtotal", value: 6.0)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.subtotal, 6.0)
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedSubTotal_ThenEncodeSubtotalKey(){
        
        let payment = ATHMPayment(total: 3)
        payment.subtotal = 2
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            XCTAssertEqual($0["subtotal"] as? Double, 2)
        }
        
    }
    
    func testWhenDecodePayment_GivenExpectedTax_ThenDecodeTax(){
        
        let paymentDic = self.getMockData(key: "tax", value: 3.0)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.tax, 3.0)
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedTax_ThenEncodeTaxKey(){
        
        let payment = ATHMPayment(total: 3)
        payment.tax = 9
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            XCTAssertEqual($0["tax"] as? Double, 9)
        }
        
    }
    
    func testWhenDecodePayment_GivenExpectedMetadata1_ThenDecodeMetadata1(){
        
        let paymentDic = self.getMockData(key: "metadata1", value: "This is valid metadata 1")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata1, "This is valid metadata 1")
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedMetadata1_ThenEncodeMetadata1Key(){
        
        let payment = ATHMPayment(total: 3)
        payment.metadata1 = "This is valid metadata 1"
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            XCTAssertEqual($0["metadata1"] as? String, "This is valid metadata 1")
        }
        
    }
    
    func testWhenDecodePayment_GivenExpectedMetadata2_ThenDecodeMetadata2(){
        
        let paymentDic = self.getMockData(key: "metadata2", value: "This is valid metadata 2")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata2, "This is valid metadata 2")
        }
        
    }
    
    func testWhenEncodePayment_GivenExpectedMetadata2_ThenEncodeMetadata2Key(){
        
        let payment = ATHMPayment(total: 3)
        payment.metadata2 = "This is valid metadata 2"
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            XCTAssertEqual($0["metadata2"] as? String, "This is valid metadata 2")
        }
        
    }
    
    func testWhenDecodePayment_GivenExpectedItems_ThenDecodePaymentItems(){
        
        let itemDic = [["name": "test 1", "quantity": 1, "price": 2, "desc": "test 1"],
                        ["name": "test 2", "quantity": 1, "price": 2, "desc": "test 2"]]
        let paymentDic = self.getMockData(key: "items", value: itemDic)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.items.count, 2)
        }
        
    }
    
    func testWhenEncodePayment_GivenTwoExpectedItems_ThenEncodeItemsKey(){
        
        let payment = ATHMPayment(total: 3)
        payment.items = [ATHMPaymentItem(name: "Test 1", price: 1, quantity: 1),
                        ATHMPaymentItem(name: "Test 2", price: 2, quantity: 2)]
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            let items = $0["items"] as? [Any]
            XCTAssertEqual(items?.count, 2)
        }
    }

    //MARK:- Negative
    
    func testWhenDecodePayment_GivenZeroTotal_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "total", value: 0)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { (error) in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
    }
    
    func testWhenEncodePayment_GivenZeroTotal_ThenThrowsAnException(){
        
        let payment = PaymentCoder(payment: ATHMPayment(total: 0))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenZeroSubTotal_ThenEncodeSubtotalAsZero(){
        
        let paymentData = getMockData(key: "subtotal", value: 0)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentData) {
            XCTAssertEqual($0?.payment.subtotal, 0)
        }
    }
    
    func testWhenEncodePayment_GivenZeroSubTotal_ThenEncodeSubtotalAsZero(){
        
        let payment = ATHMPayment(total: 1)
        payment.subtotal = 0
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            XCTAssertEqual($0["subtotal"] as? Double, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenZeroTax_ThenEncodeTaxAsZero(){
        
        let paymentData = getMockData(key: "tax", value: 0)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentData) {
            XCTAssertEqual($0?.payment.tax, 0)
        }
    }
    
    func testWhenEncodePayment_GivenZeroTax_ThenEncodeTaxAsZero(){
        
        let payment = ATHMPayment(total: 1)
        payment.tax = 0
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            XCTAssertEqual($0["tax"] as? Double, 0)
        }
        
    }
    
    func testWhenDecoderPayment_GivenMetadata1Key_ThenDecodeMetadata1AsEmptyString(){
        
        let paymentDic = self.getMockData(key: "metadata1", value: "")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata1, "")
        }
    }
    
    func testWhenEncodePayment_GivenEmptyMetadata1_ThenEncoderMetadata1AsEmptyString(){
        
        let payment = ATHMPayment(total: 10)
        payment.metadata1 = ""
        let paymentEncoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentEncoder) {
            XCTAssertEqual($0["metadata1"] as? String, "")
        }
    }
    
    func testWhenDecoderPayment_GivenMetadata2Key_ThenDecodeMetadata2AsEmptyString(){
        
        let paymentDic = self.getMockData(key: "metadata2", value: "")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata2, "")
        }
    }
    
    func testWhenEncodePayment_GivenEmptyMetadata2_ThenEncoderMetadata2AsEmptyString(){
        
        let payment = ATHMPayment(total: 10)
        payment.metadata2 = ""
        let paymentEncoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentEncoder) {
            XCTAssertEqual($0["metadata2"] as? String, "")
        }
    }
    
    func testWhenDecodePayment_GivenEmptyItems_ThenDecodePaymentAsEmptyArray(){
        
        let items = [[String: Any]]()
        let paymentDic = self.getMockData(key: "items", value: items)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.items.count, 0)
        }
        
    }
    
    func testWhenEncodePayment_GivenEmptyItems_ThenEncodeItemsKeyAsEmptyList(){
        
        let payment = ATHMPayment(total: 3)
        payment.items = [ATHMPaymentItem]()
        let paymentCoder = PaymentCoder(payment: payment)
        
        try! XCTAssertEncode(encode: paymentCoder) {
            let items = $0["items"] as? [Any]
            XCTAssertEqual(items?.count, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenUnexpectedDictionary_ThenThrowsAnException(){
        
        var paymentDic = getMockData(key: "", value: 0)
        paymentDic.removeAll()
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { (error) in
            XCTAssert(error is ATHMPaymentError)
        }
    }
    
    //MARK:- Boundary
    
    func testWhenDecodePayment_GivenNegativeTotal_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "total", value: -5)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
        
    }
    
    func testWhenDecodePayment_GivenTotalAsHexadecimalKey_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "total", value: "total123")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
    }
    
    func testWhenDecodePayment_GivenTotalAsStringKey_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "total", value: "1234")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)
        }
    }
    
    func testWhenDecodePayment_GivenDictionaryWithoutKeyTotal_ThenThrowsAnException(){
        
        var paymentDic = getMockData(key: "total", value: 2)
        paymentDic.removeValue(forKey: "total")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenEncodePayment_GivenNegativeTotal_ThenThrowsAnException(){
        
        let payment = PaymentCoder(payment: ATHMPayment(total: -120))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodePayment_GivenTotalAsNan_ThenThrowsAnException(){
        
        let payment = PaymentCoder(payment: ATHMPayment(total: NSNumber(value: Double.nan)))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: payment, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Total data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenNegativeSubTotal_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "subtotal", value: -5)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Subtotal data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenDecodePayment_GivenNilSubTotalKey_ThenDecodeSubTotalAsDefault(){
        
        let paymentData = getMockData(key: "subtotal", value: nil)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentData) {
            XCTAssertEqual($0?.payment.subtotal, 0)
        }
    
    }
    
    func testWhenDecodePayment_GivenSubTotalAsStringKey_ThenSubtotalIsDefaultValue(){
        
        let paymentDic = getMockData(key: "subtotal", value: "1234")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.subtotal, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenSubTotalAsHasHexadeicmalKey_ThenSubtotalIsDefaultValue(){
        
        let paymentDic = getMockData(key: "subtotal", value: "subtotal1234")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.subtotal, 0)
        }
    }
    
    func testWhenEncodePayment_GivenNegativeSubTotal_ThenThrowsAnException(){
        
        let payment = ATHMPayment(total: 1)
        payment.subtotal = -102
        let paymentCoder = PaymentCoder(payment:payment )
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: paymentCoder, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Subtotal data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodePayment_GivenSubTotalAsNan_ThenThrowsAnException(){
        
        let payment = ATHMPayment(total: 1)
        payment.subtotal = NSNumber(value: Double.nan)
        let paymentCoder = PaymentCoder(payment: payment)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: paymentCoder, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Subtotal data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenDictionaryWithoutKeySubTotal_ThenSubTotalHasDefaultValue(){
        
        var paymentDic = getMockData(key: "subtotal", value: "1234")
        paymentDic.removeValue(forKey: "subtotal")

        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.subtotal, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenNegativeTax_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "tax", value: -1)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Tax data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenDecodePayment_GivenNilTaxKey_ThenDecodeTaxAsDefault(){
        
        let paymentData = getMockData(key: "tax", value: nil)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentData) {
            XCTAssertEqual($0?.payment.tax, 0)
        }
    
    }
    
    func testWhenDecodePayment_GivenTaxAsStringKey_ThenTaxIsDefaultValue(){
        
        let paymentDic = getMockData(key: "tax", value: "1234")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.tax, 0)
        }
        
    }
    
    func testWhenEncodePayment_GivenNegativeTax_ThenThrowsAnException(){
        
        let payment = ATHMPayment(total: 1)
        payment.tax = -102
        let paymentCoder = PaymentCoder(payment:payment )
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: paymentCoder, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Tax data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    func testWhenEncodePayment_GivenTaxAsNan_ThenThrowsAnException(){
        
        let payment = ATHMPayment(total: 1)
        payment.tax = NSNumber(value: Double.nan)
        let paymentCoder = PaymentCoder(payment: payment)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: paymentCoder, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Tax data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenDictionaryWithoutKeyTax_ThenTaxHasDefaultValue(){
        
        var paymentDic = getMockData(key: "tax", value: 1)
        paymentDic.removeValue(forKey: "tax")

        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.tax, 0)
        }
        
    }
    
    func testWhenDecodePayment_GivenTaxAsHasHexadecimalKey_ThenTaxIsDefaultValue(){
        
        let paymentDic = getMockData(key: "tax", value: "tax1234")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.tax, 0)
        }
    }
    
    func testWhenDecoderPayment_GivenNilMetadata1Key_ThenDecodeMetadata1AsEmptyString(){
        
        let paymentDic = self.getMockData(key: "metadata1", value: nil)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata1, "")
        }
    }
    
    func testWhenEncodePayment_GivenInvalidCharactedInMetadata1_ThenThrowsAnException(){
        
        let payment = ATHMPayment(total: 1)
        payment.metadata1 = "Qué mandarán aqui?"
        let paymentCoder = PaymentCoder(payment: payment)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: paymentCoder, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The metadata1 data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenInvalidCharactedInMetadata1_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "metadata1", value: "[Articulo X.2]")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The metadata1 data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenDecoderPayment_GivenDictionaryWithoutMetadata1Key_ThenDecodeMetadata1AsEmptyString(){
        
        var paymentDic = self.getMockData(key: "metadata1", value: nil)
        paymentDic.removeValue(forKey: "metadata1")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata1, "")
        }
    }
    
    func testWhenDecoderPayment_GivenNilMetadata2Key_ThenDecodeMetadata2AsEmptyString(){
        
        let paymentDic = self.getMockData(key: "metadata2", value: nil)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata2, "")
        }
    }
        
    func testWhenEncodePayment_GivenInvalidCharactedInMetadata2_ThenThrowsAnException(){
        
        let payment = ATHMPayment(total: 1)
        payment.metadata2 = "This is invalid metadata 2?"
        let paymentCoder = PaymentCoder(payment: payment)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: paymentCoder, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The metadata2 data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    
    func testWhenDecodePayment_GivenInvalidCharactedInMetadata2_ThenThrowsAnException(){
        
        let paymentDic = getMockData(key: "metadata2", value: "[Articulo X.2]")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "The metadata2 data type value is invalid")
            XCTAssertEqual(paymentError?.source, .response)

        }
    }
    
    func testWhenDecoderPayment_GivenDictionaryWithoutMetadata2Key_ThenDecodeMetadata2AsEmptyString(){
        
        var paymentDic = self.getMockData(key: "metadata2", value: nil)
        paymentDic.removeValue(forKey: "metadata2")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.metadata2, "")
        }
    }
    
    func testWhenDecodePayment_GivenItemsValueKeyAsNil_ThenDecodePaymentAsEmptyArray(){
        
        let paymentDic = self.getMockData(key: "items", value: nil)
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.items.count, 0)
        }
    }
    
    func testWhenDecodePayment_GivenItemsKeyAsNil_ThenDecodePaymentAsEmptyArray(){
        
        var paymentDic = self.getMockData(key: "items", value: nil)
        paymentDic.removeValue(forKey: "items")
        
        try! XCTAssertDecode(codable: PaymentCoder.self, from: paymentDic) {
            XCTAssertEqual($0?.payment.items.count, 0)
        }
    }
    
    func testWhenEncodePayment_GivenInvalidItem_ThenThrowsAnException(){
        
        let payment = ATHMPayment(total: 1)
        payment.items = [ATHMPaymentItem(name: "Exception", price: -2, quantity: 0)]
        let paymentCoder = PaymentCoder(payment: payment)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: paymentCoder, assert: { _ in
            XCTAssert(false)
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
    }
    

    //MARK:- MockData
    
    func getMockData(key: String, value: Any?) -> [String: Any?]{
        
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

