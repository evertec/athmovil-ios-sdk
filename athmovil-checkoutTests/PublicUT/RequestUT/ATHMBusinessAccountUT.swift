//
//  ATHMBusinessAccountUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/31/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMBusinessAccountUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenInitBusinessAccount_GivenToken_ThenBusinessHasAToken() {
        
        let businessAccount: ATHMBusinessAccount = "12345"
        
        XCTAssertEqual(businessAccount.token, "12345")
    }
    
    func testWhenGetDescription_GivenToken_ThenBusinessDescriptionIsNotEmpty() {
        
        let businessAccount: ATHMBusinessAccount = "12345"
        
        XCTAssertFalse(businessAccount.description.isEmpty)
    }
    
    func testWhenInitBusinessAccount_GivenADictionaryWithAPublicTokenKey_ThenBusinessHasAToken() {
        
        let dicationary = NSDictionary(dictionary: ["publicToken": "Test12345"])
        let business = ATHMBusinessAccount(dictionary: dicationary)
        
        XCTAssertEqual(business.token, "Test12345")
    }
    
    func testWhenInitBusinessToken_GivenATokenDummy_ThenIsSimulatedToken() {
        
        let business: ATHMBusinessAccount = "DUMMY"
        
        XCTAssertTrue(business.isSimulatedToken)
    }
    
    func testWhenInitBusinessToken_GivenATokenDummyInADictionary_ThenIsSimulatedToken() {
        
        let dicationary = NSDictionary(dictionary: ["publicToken": "dummy"])
        let business = ATHMBusinessAccount(dictionary: dicationary)
        
        XCTAssertTrue(business.isSimulatedToken)
    }
    
    //MARK:- Negative
    
    func testWhenGetDescription_GivenEmptyToken_ThenDescriptionIsNotEmpty() {
        
        let businessAccount: ATHMBusinessAccount = "   "
        
        XCTAssertFalse(businessAccount.description.isEmpty)
    }
    
    func testWhenInitBusinessAccount_GivenEmptyToken_ThenTokenIsEmpty() {
        
        let businessAccount = ATHMBusinessAccount(token: "")
        
        XCTAssertTrue(businessAccount.token.isEmpty)
    }
    
    func testWhenInitBusinessAccount_GivenADictionaryWithAPublicTokenValueEmpty_ThenBusinessHasAEmptyToken() {
        
        let dicationary = NSDictionary(dictionary: ["publicToken": "     "])
        let business = ATHMBusinessAccount(dictionary: dicationary)
        
        XCTAssertEqual(business.token, "")
    }
    
    func testWhenInitBusinessToken_GivenAnEmptyToken_ThenIsNotSimulatedToken() {
        
        let business: ATHMBusinessAccount = ""
        
        XCTAssertFalse(business.isSimulatedToken)
    }
    
    func testWhenInitBusinessToken_GivenAnEmptyTokenDummyInADictionary_ThenIsNotSimulatedToken() {
        
        let dicationary = NSDictionary(dictionary: ["publicToken": ""])
        let business = ATHMBusinessAccount(dictionary: dicationary)
        
        XCTAssertFalse(business.isSimulatedToken)
    }
    
    //MARK:- Boundary
    
    func testWhenInitBusinessAccount_GivenADictionaryWithOutPublicTokenKey_ThenBusinessHasAEmptyToken() {
        
        let dictionary = NSDictionary(dictionary: ["anotherToken": ""])
        let business = ATHMBusinessAccount(dictionary: dictionary)
        
        XCTAssertEqual(business.token, "")
    }
    
    func testWhenInitBusinessAccount_GivenADictionaryWithAPublicTokenAsNumber_ThenBusinessHasAEmptyToken() {
        
        let dicationary = NSDictionary(dictionary: ["publicToken": 1234])
        let business = ATHMBusinessAccount(dictionary: dicationary)
        
        XCTAssertEqual(business.token, "")
    }
    
    func testWhenInitBusinessToken_GivenATokenLowerAndUpperCaseToken_ThenIsSimulatedToken() {
        
        let business: ATHMBusinessAccount = "DuMMY"
        
        XCTAssertTrue(business.isSimulatedToken)
    }
    
    func testWhenInitBusinessToken_GivenATokenLowerAndUpperCaseTokenInADictionary_ThenIsSimulatedToken() {
        
        let dicationary = NSDictionary(dictionary: ["publicToken": "DuMMY"])
        let business = ATHMBusinessAccount(dictionary: dicationary)
        
        XCTAssertTrue(business.isSimulatedToken)
    }
}

