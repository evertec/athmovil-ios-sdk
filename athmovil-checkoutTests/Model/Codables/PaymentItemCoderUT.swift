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

class PaymentItemCoderUT: XCTestCase{
    

    //MARK:- Positive
    
    func testWhenDecodePaymentItem_GivenExpectedName_ThenDecodeName(){
        
        let dicName = getDataMock(key: "name", value: "Mofongo")
        
        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dicName, assert: {
            XCTAssertEqual($0?.item.name, "Mofongo")
        })
    }
    
    func testWhenEncodePaymentItem_GivenExpectedName_ThenPaymentItemHasName(){
        
        let item = ATHMPaymentItem(name: "Test", price: NSNumber(1), quantity: 1)
        let itemDecoder = PaymentItemCoder(item: item)
        
        try! XCTAssertEncode(encode: itemDecoder) {
            XCTAssertEqual($0["name"] as? String, "Test")
        }
    }
    
    func testWhenEncodePaymentItem_GivenExpectedPrice_ThenEncodeKeyPrice(){
        
        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        let itemCoder = PaymentItemCoder(item: item)
        
        try! XCTAssertEncode(encode: itemCoder) {
            XCTAssertEqual($0["price"] as? Double, 10.0)
        }
    }
    
    func testWhenDecodePaymentItem_GivenExpectedPrice_ThenDecodePrice(){

        let dicName = getDataMock(key: "price", value: 20)
        
        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dicName, assert: {
            XCTAssertEqual($0?.item.price.doubleValue, 20.0)
        })
    }

    func testWhenEncodePaymentItem_GivenExpectedQuantity_ThenEncodeKeyQuantity(){

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        let itemCoder = PaymentItemCoder(item: item)
        
        try! XCTAssertEncode(encode: itemCoder, assert: { itemDic in
            XCTAssertEqual(itemDic["quantity"] as? Int, 1)
        })
    }

    func testWhenDecodePaymentItem_GivenExpectedQuantity_ThenDecodeQuantity(){
        
        let dicName = getDataMock(key: "quantity", value: 1)
        
        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dicName, assert: {
            XCTAssertEqual($0?.item.quantity, 1)
        })
    }

    func testWhenEncodePaymentItem_GivenExpectedDesc_ThenEncodeKeyDesc(){

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.desc = "test"
        let itemCoder = PaymentItemCoder(item: item)

        try! XCTAssertEncode(encode: itemCoder, assert: {
            XCTAssertEqual($0["desc"] as? String, "test")
        })
    }

    func testWhenDecodePaymentItem_GivenExpectedDesc_ThenDecodeDesc(){

        let dicName = getDataMock(key: "desc", value: "Mofongo de pollo y camarones")
        
        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dicName, assert: {
            XCTAssertEqual($0?.item.desc, "Mofongo de pollo y camarones")
        })

    }

    func testWhenEncodePaymentItem_GivenExpectedMetadata_ThenEncodeMetadata(){

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.metadata = "This is valid metadata"
        let itemCoder = PaymentItemCoder(item: item)

        try! XCTAssertEncode(encode: itemCoder, assert: {
            XCTAssertEqual($0["metadata"] as? String, "This is valid metadata")
        })
    }

    func testWhenDecodePaymentItem_GivenExpectedMetadata_ThenDecodeMetadata(){

        let dicName = getDataMock(key: "metadata", value: "This is valid metadata")
        
        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dicName, assert: {
            XCTAssertEqual($0?.item.metadata, "This is valid metadata")
        })
    }

    func testWhenGetDescription_GivenItem_ThenPrintPaymentItem(){
        let item = ATHMPaymentItem(name: "Test Item", price: NSNumber(20), quantity: 1)

        item.metadata = "desc"

        XCTAssertFalse(item.description.isEmpty)
    }


     //MARK:- Negative

    func testWhenEncodePaymentItem_GivenEmptyName_ThenThrowsAnException(){

        let item = PaymentItemCoder(item: ATHMPaymentItem(name: "  ", price: NSNumber(1), quantity: 1))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
            
        })) { (error) in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Item's name value is required")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }

    func testWhenDecodePaymentItem_GivenEmptyName_ThenThrowsAnException(){

        let item = self.getDataMock(key: "name", value: "")

        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: item, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's name value is required")
            XCTAssertEqual(paymentError!.source, .response)
        }
        
    }

    func testWhenEncodePaymentItem_GivenZeroPrice_ThenThrowsAnException(){

        let item = PaymentItemCoder(item: ATHMPaymentItem(name: "Test", price: NSNumber(0), quantity: 1))

        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
            
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
        
    }

    func testWhenDecodePaymentItem_GivenZeroPrice_ThenThrowsAnException(){

        let itemDic = getDataMock(key: "price", value: 0.0)

        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenZeroQuantity_ThenThrowsAnException(){

        let item = PaymentItemCoder(item: ATHMPaymentItem(name: "Test", price: NSNumber(1), quantity: 0))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
            
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
    }

    func testWhenDecodePaymentItem_GivenZeroQuantity_ThenThrowsAnException(){

        let itemDic = getDataMock(key: "quantity", value: 0)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenEmptyDesc_ThenEncodeKeyDescAsEmpty(){

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.desc = "   "
        let itemCoder = PaymentItemCoder(item: item)

        try! XCTAssertEncode(encode: itemCoder) {
            XCTAssertEqual($0["desc"] as? String, "   ")
        }
    }

    func testWhenDecodePaymentItem_GivenEmptyDesc_ThenDecodeDesc(){

        let dic = getDataMock(key: "desc", value: "")

        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dic) {
            XCTAssertEqual($0?.item.desc, "")
        }
    }

    func testWhenEncodePaymentItem_GivenEmptyMetadata_ThenEncodeMetadataAsEmptyString(){

        let item = ATHMPaymentItem(name: "Test", price: NSNumber(10.0), quantity: 1)
        item.metadata = ""
        let itemDecoder = PaymentItemCoder(item: item)
        
        try! XCTAssertEncode(encode: itemDecoder) {
            XCTAssertEqual($0["metadata"] as? String, "")
        }
                
    }

    func testWhenDecodePaymentItem_GivenEmptyMetadata_ThenDecodeMetadataAsEmpty(){

        let dic = getDataMock(key: "metadata", value: "")

        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dic) {
            XCTAssertEqual($0?.item.metadata, "")
        }
    }

    func testWhenGetDescription_GivenItemAndOptionalProperties_ThenPrintPaymentItem(){
        let item = ATHMPaymentItem(name: "Test Item", price: NSNumber(20), quantity: 1)

        XCTAssertFalse(item.description.isEmpty)
    }

    //MARK:- Boundary

    func testWhenDecodePaymentItem_GivenNilNameValue_ThenThrowsAnException(){

        let itemDic = getDataMock(key: "name", value: nil)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's name value is required")
            XCTAssertEqual(paymentError.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenNilPriceKey_ThenThrowsAnException(){
        
        let itemDic = getDataMock(key: "price", value: nil)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenNegativePriceValue_ThenThrowsAnException(){

        let itemDic = getDataMock(key: "price", value: -20.0)
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenLagePriceAndStringValue_ThenThrowsAnException(){
        
        let itemDic = getDataMock(key: "price", value: "3921839217434612398213912498")

        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenEmptyNegativePrice_ThenThrowsAnException(){

        let item = PaymentItemCoder(item: ATHMPaymentItem(name: "Test", price: NSNumber(-20), quantity: 1))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's price data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
    }

    func testWhenDecodePaymentItem_GivenNilQuantityKey_ThenGetPropertyQuantityAsZero(){

        let itemDic = getDataMock(key: "quantity", value: nil)

        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
        
    }

    func testWhenDecodePaymentItem_GivenNegativeQuantityValue_ThenThrowsAnException(){

        let itemDic = getDataMock(key: "quantity", value: -20.0)

        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenDecodePaymentItem_GivenLageQuantityAndStringValue_ThenThrowsAnException(){
        
        let itemDic = getDataMock(key: "quantity", value: "3921839217434612398213912498")

        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }

    func testWhenEncodePaymentItem_GivenQuantityNegativePrice_ThenThrowsAnException(){

        let item = PaymentItemCoder(item: ATHMPaymentItem(name: "Test", price: NSNumber(20), quantity: -1))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: item, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's quantity data type value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
    }

    func testWhenDecodePaymentItem_GivenNilDescValue_ThenDecodeDescAsEmptyString(){

        let dic = getDataMock(key: "desc", value: nil)
        
        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: dic) {
            XCTAssertEqual($0?.item.desc, "")
        }

    }

    func testWhenEncodePaymentItem_GivenUnexpectedMetadata_ThenThrowsAnException(){

        let paymentItem = ATHMPaymentItem(name: "Name", price: NSNumber(1), quantity: 1)
        paymentItem.metadata = "Quién sabe que manden aquí"
        let itemCoder = PaymentItemCoder(item: paymentItem)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: itemCoder, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as! ATHMPaymentError
            XCTAssertEqual(paymentError.failureReason, "Item's metadata value is invalid")
            XCTAssertEqual(paymentError.source, .request)
        }
        
    }

    func testWhenDecodePaymentItem_GivenUnexpectedMetadata_ThenThrowsAnException(){

        let itemDic = getDataMock(key: "metadata", value: "{Qué mandaran?}")
        
        XCTAssertThrowsError(try XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic, assert: { _ in
            XCTAssert(false)
        })) {
            let paymentError = $0 as? ATHMPaymentError
            XCTAssertEqual(paymentError!.failureReason, "Item's metadata value is invalid")
            XCTAssertEqual(paymentError!.source, .response)
        }
    }
    
    func testWhenDecodePaymentItem_GivenNilMetadata_ThenDecodeMetadataAsEmptyString(){

        let itemDic = getDataMock(key: "metadata", value: nil)
        
        try! XCTAssertDecode(codable: PaymentItemCoder.self, from: itemDic) {
            XCTAssertEqual($0?.item.metadata, "")
        }
        
    }

    func testWhenDecodePaymentItem_GivenUnexpectedDictionary_ThenThowsAnException(){

        let unexpectedData = "[]".toData
        let encoder = JSONDecoder()

        XCTAssertThrowsError(try encoder.decode(PaymentItemCoder.self, from: unexpectedData!)) {
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

