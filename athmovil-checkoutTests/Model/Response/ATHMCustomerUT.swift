//
//  ATHMCustomerUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/31/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import  XCTest
@testable import athmovil_checkout

class ATHMCustomerUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenInitCustomer_GivenName_ThenInstanceHasAName(){
        
        let customer = ATHMCustomer(name: "Test", phoneNumber: "", email: "")
        
        XCTAssertEqual(customer.name, "Test")
    }
    
    func testWhenInitCustomer_GivenPhoneNumber_ThenInstanceHasAPhoneNumber(){
        
        let customer = ATHMCustomer(name: "Test", phoneNumber: "7871234567", email: "")
        
        XCTAssertEqual(customer.phoneNumber, "7871234567")
        
    }
    
    func testWhenInitCustomer_GivenEmail_ThenInstanceHasAEmail(){
        
        let customer = ATHMCustomer(name: "Test", phoneNumber: "7871234567", email: "test@evertecinc.com")
        
        XCTAssertEqual(customer.email, "test@evertecinc.com")
    }
    
    func testWhenGetDescription_GivenCustomer_ThenPrintCustomer(){
        
        let customer = ATHMCustomer(name: "Test", phoneNumber: "7871234567", email: "test@evertecinc.com")
        
        XCTAssertFalse(customer.description.isEmpty)
    }
    
    //MARK:- Negative
    
    func testWhenGetDescription_GivenCustomerWithEmptyProperties_ThenPrintCustomer(){
        
        let customer = ATHMCustomer(name: "", phoneNumber: "", email: "")
        
        XCTAssertFalse(customer.description.isEmpty)
    }
    
    //MARK:- Boundary
    
}

