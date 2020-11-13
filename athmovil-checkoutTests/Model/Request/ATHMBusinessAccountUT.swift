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

class ATHMBusinessAccountUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenInitBusinessAccount_GivenToken_ThenBusinessHasAToken(){
        
        let token = "12345"
        let businessAccount = ATHMBusinessAccount(token: "12345")
        
        XCTAssertEqual(token, businessAccount.token)
    }
    
    func testWhenGetDescription_GivenToken_ThenBusinessDescriptionIsNotEmpty(){
        
        let businessAccount = ATHMBusinessAccount(token: "12345")
        
        XCTAssertFalse(businessAccount.description.isEmpty)
    }
    
    //MARK:- Negative
    
    func testWhenGetDescription_GivenEmptyToken_ThenDescriptionIsNotEmpty(){
        
        let businessAccount = ATHMBusinessAccount(token: "   ")
        
        XCTAssertFalse(businessAccount.description.isEmpty)
    }
    
    
    func testWhenInitBusinessAccount_GivenEmptyToken_ThenTokenIsEmpty(){
        
        let businessAccount = ATHMBusinessAccount(token: "")
        
        XCTAssertTrue(businessAccount.token.isEmpty)
    }
    
    //MARK:- Boundary
    
}

