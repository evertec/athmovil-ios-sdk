//
//  PaymentItemCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 6/16/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class PaymentItemCoderUT: XCTestCase {
    

    //MARK:- Positive
    
    func testWhenDecodePaymentItem_GivenExpectedName_ThenDecodeName() {
        
        let dicName = getDataMock(key: "name", value: "Mofongo")
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dicName, assert: {
                XCTAssertEqual($0?.name, "Mofongo")
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }
    
    func testWhenEncodePaymentItem_GivenExpectedName_ThenPaymentItemHasName() {
        
        let item = ATHMPaymentItem(name: "Test", price: NSNumber(1), quantity: 1)
        
        do {
            try XCTAssertEncode(encode: item) {
                XCTAssertEqual($0["name"] as? String, "Test")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }
    
    func testWhenEncodePaymentItem_GivenExpectedPrice_ThenEncodeKeyPrice() {
        
        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        
        do {
            try XCTAssertEncode(encode: item) {
                XCTAssertEqual($0["price"] as? Double, 10.0)
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }
    
    func testWhenDecodePaymentItem_GivenExpectedPrice_ThenDecodePrice() {

        let dicName = getDataMock(key: "price", value: 20)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dicName, assert: {
                XCTAssertEqual($0?.price.doubleValue, 20.0)
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenEncodePaymentItem_GivenExpectedQuantity_ThenEncodeKeyQuantity() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        
        do {
            try XCTAssertEncode(encode: item, assert: { itemDic in
                XCTAssertEqual(itemDic["quantity"] as? Int, 1)
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenDecodePaymentItem_GivenExpectedQuantity_ThenDecodeQuantity() {
        
        let dicName = getDataMock(key: "quantity", value: 1)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dicName, assert: {
                XCTAssertEqual($0?.quantity, 1)
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenEncodePaymentItem_GivenExpectedDesc_ThenEncodeKeyDesc() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.desc = "test"

        do {
            try XCTAssertEncode(encode: item, assert: {
                XCTAssertEqual($0["desc"] as? String, "test")
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenDecodePaymentItem_GivenExpectedDesc_ThenDecodeDesc() {

        let dicName = getDataMock(key: "desc", value: "Mofongo de pollo y camarones")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dicName, assert: {
                XCTAssertEqual($0?.desc, "Mofongo de pollo y camarones")
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }

    }

    func testWhenEncodePaymentItem_GivenExpectedMetadata_ThenEncodeMetadata() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.metadata = "This is valid metadata"

        do {
            try XCTAssertEncode(encode: item, assert: {
                XCTAssertEqual($0["metadata"] as? String, "This is valid metadata")
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenDecodePaymentItem_GivenExpectedMetadata_ThenDecodeMetadata() {

        let dicName = getDataMock(key: "metadata", value: "This is valid metadata")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dicName, assert: {
                XCTAssertEqual($0?.metadata, "This is valid metadata")
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenGetDescription_GivenItem_ThenPrintPaymentItem() {
        let item = ATHMPaymentItem(name: "Test Item", price: NSNumber(20), quantity: 1)
        item.metadata = "desc"

        XCTAssertFalse(item.description.isEmpty)
    }

     //MARK:- Negative

    func testWhenEncodePaymentItem_GivenEmptyName_ThenThrowsAnException() {

        let item = ATHMPaymentItem(name: "  ", price: NSNumber(1), quantity: 1)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
            
        })) { (error) in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Item's name value is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }

    func testWhenDecodePaymentItem_GivenEmptyName_ThenThrowsAnException() {

        let item = getDataMock(key: "name", value: "")

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: item, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's name value is required")
            XCTAssertEqual(paymentError!.source, .response)
        }
        
    }

    func testWhenEncodePaymentItem_GivenZeroPrice_ThenThrowsAnException() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(0), quantity: 1)

        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
            
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
        
    }

    func testWhenDecodePaymentItem_GivenZeroPrice_ThenThrowsAnException() {

        let itemDic = getDataMock(key: "price", value: 0.0)

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenZeroQuantity_ThenThrowsAnException() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(1), quantity: 0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
            
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
    }

    func testWhenDecodePaymentItem_GivenZeroQuantity_ThenThrowsAnException() {

        let itemDic = getDataMock(key: "quantity", value: 0)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenEmptyDesc_ThenEncodeKeyDescAsEmpty() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.desc = "   "

        do {
            try XCTAssertEncode(encode: item) {
                XCTAssertEqual($0["desc"] as? String, "   ")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenDecodePaymentItem_GivenEmptyDesc_ThenDecodeDesc() {

        let dic = getDataMock(key: "desc", value: "")

        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dic) {
                XCTAssertEqual($0?.desc, "")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenEncodePaymentItem_GivenEmptyMetadata_ThenEncodeMetadataAsEmptyString() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.metadata = ""
        
        do {
            try XCTAssertEncode(encode: item) {
                XCTAssertEqual($0["metadata"] as? String, "")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
                
    }

    func testWhenDecodePaymentItem_GivenEmptyMetadata_ThenDecodeMetadataAsEmpty() {

        let dic = getDataMock(key: "metadata", value: "")

        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dic) {
                XCTAssertEqual($0?.metadata, "")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenGetDescription_GivenItemAndOptionalProperties_ThenPrintPaymentItem() {
        let item = ATHMPaymentItem(name: "Test Item", price: NSNumber(20), quantity: 1)

        XCTAssertFalse(item.description.isEmpty)
    }

    //MARK:- Boundary

    func testWhenDecodePaymentItem_GivenNilNameValue_ThenThrowsAnException() {

        let itemDic = getDataMock(key: "name", value: nil)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's name value is required")
            XCTAssertEqual(paymentError.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenNilPriceKey_ThenThrowsAnException() {
        
        let itemDic = getDataMock(key: "price", value: nil)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenNegativePriceValue_ThenThrowsAnException() {

        let itemDic = getDataMock(key: "price", value: -20.0)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenLagePriceAndStringValue_ThenThrowsAnException() {
        
        let itemDic = getDataMock(key: "price", value: "3921839217434612398213912498")

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenEmptyNegativePrice_ThenThrowsAnException() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(-20), quantity: 1)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
    }

    func testWhenDecodePaymentItem_GivenNilQuantityKey_ThenGetPropertyQuantityAsZero() {

        let itemDic = getDataMock(key: "quantity", value: nil)

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
        
    }

    func testWhenDecodePaymentItem_GivenNegativeQuantityValue_ThenThrowsAnException() {

        let itemDic = getDataMock(key: "quantity", value: -20.0)

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenLageQuantityAndStringValue_ThenThrowsAnException() {
        
        let itemDic = getDataMock(key: "quantity", value: "3921839217434612398213912498")

        XCTAssertThrowsError(try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenQuantityNegativePrice_ThenThrowsAnException() {

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(20), quantity: -1)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
    }

    func testWhenDecodePaymentItem_GivenNilDescValue_ThenDecodeDescAsEmptyString() {

        let dic = getDataMock(key: "desc", value: nil)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: dic) {
                XCTAssertEqual($0?.desc, "")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }

    }

    func testWhenEncodePaymentItem_GivenEspecialCharactersInMetadata_ThenCanEncodeMetadata() {

        let paymentItem = ATHMPaymentItem(name: "Name", price: NSNumber(1), quantity: 1)
        paymentItem.metadata = "Example Metadata:?@|_'\"{}^–!@#%$?:[]"
        
        do {
            try XCTAssertEncode(encode: paymentItem, assert: {
                XCTAssertNotNil($0["metadata"] as? String)
            })
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }

    func testWhenDecodePaymentItem_GivenEspecialCharactersInMetadata_ThenCanDecodeMetadata() {

        let itemDic = getDataMock(key: "metadata", value: "Example Metadata:?@|_'\"{}^–!@#%$?:[]")
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic) {
                XCTAssertEqual($0?.metadata, "Example Metadata:?@|_'\"{}^–!@#%$?:[]")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
    }
    
    func testWhenDecodePaymentItem_GivenNilMetadata_ThenDecodeMetadataAsEmptyString() {

        let itemDic = getDataMock(key: "metadata", value: nil)
        
        do {
            try XCTAssertDecode(codable: ATHMPaymentItem.self, from: itemDic) {
                XCTAssertEqual($0?.metadata, "")
            }
        } catch {
            XCTFail("Error decoded ATHMPaymentItem: \(error)")
        }
        
    }

    func testWhenDecodePaymentItem_GivenUnexpectedDictionary_ThenThowsAnException() {

        let unexpectedData = "[]".toData
        let encoder = JSONDecoder()

        XCTAssertThrowsError(try encoder.decode(ATHMPaymentItem.self, from: unexpectedData!)) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }

    }


    //MARK:- MockData

    func getDataMock(key: String, value: Any?) -> [String : Any?] {
        var dicMock: [String: Any?] = ["name": "ItemTest",
                                       "price": 2.0,
                                       "quantity": 1,
                                       "desc": "Description",
                                       "metadata": "Metadata"]

        dicMock[key] = value
        return dicMock
    }
    
}

