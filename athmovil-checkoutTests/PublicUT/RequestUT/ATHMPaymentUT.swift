//
//  ATHMPaymentUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenInitPayment_GivenTotal_ThenPaymentHasTotal() {
        
        let payment: ATHMPayment = 1.0
        
        XCTAssertEqual(payment.total, 1)
    }
    
    func testWhenInitPayment_GivenSubTotal_ThenPaymentHasSubTotal() {
        
        let payment: ATHMPayment = 1.0
        payment.subtotal = 2
        
        XCTAssertEqual(payment.subtotal, 2)
    }
    
    func testWhenInitPayment_GivenTax_ThenPaymentHasTax() {
        
        let payment: ATHMPayment = 1.0
        payment.tax = 3
        
        XCTAssertEqual(payment.tax, 3)
    }
    
    func testWhenInitPayment_GivenMetadata1_ThenPaymentMetadata1() {
        
        let payment: ATHMPayment = 1.0
        payment.metadata1 = "Metadata 1"
        
        XCTAssertEqual(payment.metadata1, "Metadata 1")
    }
    
    func testWhenInitPayment_GivenMetadata2_ThenPaymentMetadata2() {
        
        let payment: ATHMPayment = 1.0
        payment.metadata2 = "Metadata 2"
        
        XCTAssertEqual(payment.metadata2, "Metadata 2")
    }
    
    func testWhenInitPayment_GivenItemsArray_ThenPaymentHasItems() {
        
        let payment: ATHMPayment = 1.0
        payment.items.append(ATHMPaymentItem(name: "test 1", price: 1, quantity: 1))
        payment.items.append(ATHMPaymentItem(name: "test 2", price: 1, quantity: 1))
        
        XCTAssertEqual(payment.items.count, 2)
    }
    
    func testWhenGetDescription_GivenPayment_ThenPrintPaymentDescription() {
        
        let payment: ATHMPayment = 2.0
        payment.subtotal = 1
        payment.tax = 1
        payment.metadata1 = "test metadata 1"
        payment.metadata2 = "test metadata 2"
        payment.items = [ATHMPaymentItem(name: "test", price: 1, quantity: 1)]
        
        XCTAssertFalse(payment.description.isEmpty)
    }
    
    func testWhenInitPayment_GivenTotalInADictionary_ThenPaymentHasTotal() {
        
        let payment = ATHMPayment(dictionary: NSDictionary(dictionary: ["total": 20]))
        
        XCTAssertEqual(payment.total, 20)
    }
    
    //MARK:- Negative
    
    func testWhenInitPayment_GivenZeroTotal_ThenPaymentHasTotal() {
        
        let payment: ATHMPayment = 0.0
        
        XCTAssertEqual(payment.total, 0)
    }
    
    func testWhenInitPayment_GivenZeroSubTotal_ThenPaymentHasSubTotal() {
        
        let payment: ATHMPayment = 1.0
        payment.subtotal = 0
        
        XCTAssertEqual(payment.subtotal, 0)
    }
    
    func testWhenInitPayment_GivenZeroTax_ThenPaymentHasTax() {
        
        let payment: ATHMPayment = 1.0
        payment.tax = 0
        
        XCTAssertEqual(payment.tax, 0)
    }
    
    func testWhenInitPayment_GivenEmptyMetadata1_ThenPaymentMetadata1IsEmpty() {
        
        let payment: ATHMPayment = 1.0
        payment.metadata1 = ""
        
        XCTAssertEqual(payment.metadata1, "")
    }
    
    func testWhenInitPayment_GivenEmptyMetadata2_ThenPaymentMetadata2IsEmpty() {
        
        let payment: ATHMPayment = 1.0
        payment.metadata2 = ""
        
        XCTAssertEqual(payment.metadata2, "")
    }
    
    func testWhenInitPayment_GivenEmptyItemsArray_ThenPaymentHasItems() {
        
        let payment: ATHMPayment = 1.0
        payment.items = [ATHMPaymentItem]()
        
        XCTAssertEqual(payment.items.count, 0)
    }
    
    func testWhenGetDescription_GivenPaymentDefaultProperties_ThenPrintPaymentDescription() {
        
        let payment: ATHMPayment = 2.0
    
        XCTAssertFalse(payment.description.isEmpty)
    }
    
    func testWhenInitPayment_GivenAnEmptyDictionary_ThenTotalPaymentIsZero() {
        
        let payment = ATHMPayment(dictionary: NSDictionary(dictionary: [String: Any]()))
        
        XCTAssertEqual(payment.total, 0)
    }
     
    //MARK:- Boundary
    
    func testWhenInitPayment_GivenAnDictionaryWithANegativeTotal_ThenTotalPaymentIsZero() {
        
        let payment = ATHMPayment(dictionary: NSDictionary(dictionary: ["total": -20]))
        
        XCTAssertEqual(payment.total, -20)
    }
}

