//
//  NSDictionaryUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/7/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class NSDictionaryUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenGetStringBySubscript_GivenADictionaryWithAStringValue_ThenGetAStringFromDictionary(){
        
        let dictionary = NSDictionary(dictionary: ["Test": "Hello"])
        
        let result: String = dictionary["Test"]
        
        XCTAssertEqual(result, "Hello")
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithANumberValue_ThenGetANumberFromDictionary(){
        
        let dictionary = NSDictionary(dictionary: ["TestNumber": NSNumber(1)])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertEqual(result, 1)
    }
    
    func testWhenGetArrayBySubscript_GivenADictionaryWithAArrayValue_ThenGetAnArrayFromDictionary(){
        
        let nestedDictionary = NSDictionary(dictionary: ["NestedDic": 1])
        let dictionary = NSDictionary(dictionary: ["TestNestedDictionary": [nestedDictionary]])
        
        let result: [NSDictionary] = dictionary["TestNestedDictionary"]
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithAIntegerValue_ThenGetAIntegerFromDictionary(){
        
        let dictionary = NSDictionary(dictionary: ["TestInt": 5])
        
        let result: NSNumber = dictionary["TestInt"]
        
        XCTAssertEqual(result, 5)
    }
    
    //MARK:- Negative
    
    func testWhenGetStringBySubscript_GivenADictionaryWithAnEmptyStringValue_ThenGetAStringFromDictionary(){
        
        let dictionary = NSDictionary(dictionary: ["Test": ""])
        
        let result: String = dictionary["Test"]
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithAnEmptyNumberValue_ThenGetAZeroFromDictionary(){
        
        let dictionary = NSDictionary(dictionary: ["TestNumber": NSNumber(value: Double.nan)])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertTrue(result.doubleValue.isNaN)
    }
    
    func testWhenGetArrayBySubscript_GivenADictionaryWithAEmptyArrayValue_ThenGetAnEmptyArrayFromDictionary(){
        
        let nestedDictionary = NSDictionary()
        let dictionary = NSDictionary(dictionary: ["TestNestesDictionary": nestedDictionary])
        
        let result: [NSDictionary] = dictionary["TestNestesDictionary"]
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithAnEmptyIntegerValue_ThenGetAZeroFromDictionary(){
        
        let dictionary = NSDictionary(dictionary: ["TestInteger": ""])
        
        let result: NSNumber = dictionary["TestInteger"]
        
        XCTAssertEqual(result, 0)
    }
    
    //MARK:- Boundary
    
    func testWhenGetStringBySubscript_GivenADictionaryWithOutAKey_ThenGetAnEmptyString(){
        
        let dictionary = NSDictionary(dictionary: ["": "Hello"])
        
        let result: String = dictionary["Test"]
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testWhenGetStringBySubscript_GivenADictionaryWithAnStringValue_ThenGetATrimStringFromDictionary(){
        
        let dictionary = NSDictionary(dictionary: ["Test": "   Hello   "])
        
        let result: String = dictionary["Test"]
        
        XCTAssertEqual(result, "Hello")
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithOutAKey_ThenGetAZero(){
        
        let dictionary = NSDictionary(dictionary: ["": NSNumber(2)])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertEqual(result, 0)
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithANegativeValue_ThenGetANegativeNumber(){
        
        let dictionary = NSDictionary(dictionary: ["TestNumber": NSNumber(-2)])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertEqual(result, -2)
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithANumberInAString_ThenGetANumber(){
        
        let dictionary = NSDictionary(dictionary: ["TestNumber": "1234"])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertEqual(result, 1234)
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithAlphaNumericString_ThenGetAZeroValue(){
        
        let dictionary = NSDictionary(dictionary: ["TestNumber": "Test1234"])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertEqual(result, 0)
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithADecimalNumberInAString_ThenGetANumberWithDecimals(){
        
        let dictionary = NSDictionary(dictionary: ["TestNumber": "3.999999999"])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertEqual(result, 3.999999999)
    }
    
    func testWhenGetNumberBySubscript_GivenADictionaryWithADecimalNumber_ThenGetANumberWithDecimals(){
        
        let dictionary = NSDictionary(dictionary: ["TestNumber": 4.33333333])
        
        let result: NSNumber = dictionary["TestNumber"]
        
        XCTAssertEqual(result, 4.33333333)
    }
    
    func testWhenGetArrayBySubscript_GivenADictionaryWithOutAKey_ThenGetAnEmptyArrayFromDictionary(){
        
        let nestedDictionary = NSDictionary()
        let dictionary = NSDictionary(dictionary: ["Test": nestedDictionary])
        
        let result: [NSDictionary] = dictionary["TestNestesDictionary"]
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithOutAKey_ThenGetAZero(){
        
        let dictionary = NSDictionary(dictionary: ["": 10])
        
        let result: Int = dictionary["TestInteger"]
        
        XCTAssertEqual(result, 0)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithANegativeValue_ThenGetANegativeInteger(){
        
        let dictionary = NSDictionary(dictionary: ["TestInteger": -20])
        
        let result: Int = dictionary["TestInteger"]
        
        XCTAssertEqual(result, -20)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithAIntegerInAString_ThenGetAInteger(){
        
        let dictionary = NSDictionary(dictionary: ["TestInteger": "2020"])
        
        let result: Int = dictionary["TestInteger"]
        
        XCTAssertEqual(result, 2020)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithAIntegerAndDecimals_ThenGetAZero(){
        
        let dictionary = NSDictionary(dictionary: ["TestInteger": 2021.23])
        
        let result: Int = dictionary["TestInteger"]
        
        XCTAssertEqual(result, 0)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithAIntegerAndDecimalsInAStringValue_ThenGetAInteger(){
        
        let dictionary = NSDictionary(dictionary: ["TestInteger": "0.1222"])
        
        let result: Int = dictionary["TestInteger"]
        
        XCTAssertEqual(result, 0)
    }
    
    func testWhenGetIntegerBySubscript_GivenADictionaryWithAlphaNumericString_ThenGetAZeroValue(){
        
        let dictionary = NSDictionary(dictionary: ["TestInteger": "Test1234"])
        
        let result: Int = dictionary["TestInteger"]
        
        XCTAssertEqual(result, 0)
    }
}
