//
//  ATHMPaymentItemUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/31/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentItemUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenInitPaymentItem_GivenName_ThenItemHasName(){
        
        let item = ATHMPaymentItem(name: "Test", price: 0, quantity: 0)
        
        XCTAssertEqual(item.name, "Test")
        
    }
    
    func testWhenInitPaymentItem_GivenPrice_ThenItemHasPrice(){
        
        let item = ATHMPaymentItem(name: "Test", price: 10, quantity: 0)
        
        XCTAssertEqual(item.price, 10)
        
    }
    
    func testWhenInitPaymentItem_GivenQuantity_ThenItemHasQuantity(){
        
        let item = ATHMPaymentItem(name: "Test", price: 10, quantity: 1)
        
        XCTAssertEqual(item.quantity, 1)
        
    }
    
    func testWhenInitPaymentItem_GivenDesc_ThenItemHasDesc(){
        
        let item = ATHMPaymentItem(name: "Test", price: 10, quantity: 1)
        item.desc = "Test"
        
        XCTAssertEqual(item.desc, "Test")
        
    }
    
    func testWhenInitPaymentItem_GivenEmptyName_ThenItemHasDesc(){
        
        let item = ATHMPaymentItem(name: "   ", price: 10, quantity: 1)
        
        XCTAssertTrue(item.name.isEmpty)
        
    }
    
    func testWhenInitPaymentItem_GivenEmptyDescr_ThenItemHasDesc(){
        
        let item = ATHMPaymentItem(name: "test", price: 10, quantity: 1)
        item.desc = "   "
        
        XCTAssertEqual(item.desc, "   ")
        
    }
    
    
    func testWhenItemGetDescription_GivenItem_ThenPrintItemDescription(){
        
        let item = ATHMPaymentItem(name: "Test", price: 10, quantity: 1)
        
        XCTAssertFalse(item.description.isEmpty)
        
    }
    

    
    //MARK:- Negative
    
    func testWhenItemGetDescription_GivenItemEmptyProerties_ThenPrintItemDescription(){
        
        let item = ATHMPaymentItem(name: "", price: 0, quantity: 0)
        
        XCTAssertFalse(item.description.isEmpty)
        
    }
    
    //MARK:- Boundary
    
}

