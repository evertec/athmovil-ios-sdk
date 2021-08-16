//
//  NSNumberUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/6/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class NSNumberUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenIsUnexpectedAmount_GivenAnyNumber_ThenTheAmountIsNotUnexpected(){
        
        let number = NSNumber(5)
        
        XCTAssertFalse(number.isUnexpectedAmount)
    }
    
    //MARK:- Negative
    
    func testWhenIsUnexpectedAmount_GivenNegativeNumber_ThenTheAmountIsUnExpected(){
        
        let number = NSNumber(-5)
        
        XCTAssertTrue(number.isUnexpectedAmount)
    }
    
    //MARK:- Boundary
    
    func testWhenIsUnexpectedAmount_GivenNanNumber_ThenTheAmountIsUnExpected(){
        
        let number = NSNumber()
        
        XCTAssertTrue(number.isUnexpectedAmount)
    }
    
}
