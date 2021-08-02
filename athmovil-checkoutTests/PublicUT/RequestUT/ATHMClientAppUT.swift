//
//  ATHMClientAppUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/31/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMClientAppUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenInitClientApp_GivenURLScheme_ThenHasAnURLSCheme() {
        
        let clientApp: ATHMURLScheme = "testURL"
        
        XCTAssertEqual(clientApp.urlScheme, "testURL")
        
    }
    
    func testWhenInitClientApp_GivenADictionaryWithAURLKey_ThenHasAnURLSCheme() {
        
        let dicationary = NSDictionary(dictionary: ["scheme": "URL_test"])
        let client = ATHMURLScheme(dictionary: dicationary)
        
        XCTAssertEqual(client.urlScheme, "URL_test")
        
    }
    
    func testWhenGetDescription_GivenURLScheme_ThenDescriptionIsNotEmpty() {
        
        let appClient = ATHMURLScheme(urlScheme: "xamarintest")
        
        XCTAssertFalse(appClient.description.isEmpty)
    }

    //MARK:- Negative
    
    func testWhenInitClientApp_GivenEmptyURLScheme_ThenHasANURLSChemeEmpty() {
        
        let client: ATHMURLScheme = "   "
        
        XCTAssertTrue(client.urlScheme.isEmpty)
        
    }
    
    func testWhenGetDescription_GivenEmptyURLScheme_ThenDescriptionIsNotEmpty() {
        
        let appClient = ATHMURLScheme(urlScheme: "")
        
        XCTAssertFalse(appClient.description.isEmpty)
    }
    
    func testWhenInitClientApp_GivenADictionaryWithASchemeStringEmpty_ThenURLSchemePropertyIsEmpty() {
        
        let dicationary = NSDictionary(dictionary: ["scheme": "     "])
        let client = ATHMURLScheme(dictionary: dicationary)
        
        XCTAssertEqual(client.urlScheme, "")
        
    }
    
    //MARK:- Boundary
    
    func testWhenInitClientApp_GivenADictionaryWithOutURLSchemeKey_ThenURLSchemePropertyIsEmpty() {
        
        let dicationary = NSDictionary(dictionary: ["otherKey": "URL_schem"])
        let client = ATHMURLScheme(dictionary: dicationary)
        
        XCTAssertEqual(client.urlScheme, "")
        
    }
    
    func testWhenInitClientApp_GivenADictionaryWithURLSchemeAsNumber_ThenBusinessHasAEmptyToken() {
        
        let dicationary = NSDictionary(dictionary: ["scheme": 3241312])
        let client = ATHMURLScheme(dictionary: dicationary)
        
        XCTAssertEqual(client.urlScheme, "")
    }
    
}

