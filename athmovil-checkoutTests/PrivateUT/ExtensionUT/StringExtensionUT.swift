//
//  StringUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 6/16/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class StringExtensionUT: XCTestCase {
    
    //MARK:- Positive
    
    //Clean a string with characters different to number
    func testWhenCleanAsNumber_GivenAlfaNumbericString_ThenGetOnlyNumbers() {
        
        let stringToFormat = "?¡-'`+^*^*^*7 8-73-428-23.4@"
        
        let stringAsNumber = stringToFormat.clearAsNumber()
        
        XCTAssert(stringAsNumber == "7873428234")
        
    }
    
    //MARK:- Negative
    
    func testWhenClearAsNumber_GivenEmptyString_ThenGetEmptyString() {
        
        let stringToFormat = ""
        
        let stringAsNumber = stringToFormat.clearAsNumber()
        
        XCTAssert(stringAsNumber.isEmpty)
        
    }
    
    //MARK:- Boundary
    
    func testWhenClearAsNumber_GivenMoreDigitsThanPhoneNumber_ThenCutAsTelephoneNumber() {
        
        let stringToFormat = "7771112222333"
        
        let stringAsNumber = stringToFormat.clearAsNumber()
        
        XCTAssertEqual(stringAsNumber, "1112222333")
        
    }
}
