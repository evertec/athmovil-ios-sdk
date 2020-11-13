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


class ATHMClientAppUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenInitClientApp_GivenURLScheme_ThenHasANURLSCheme(){
        
        let urlScheme = "testURL"
        let client = ATHMClientApp(urlScheme: "testURL")
        
        XCTAssertEqual(client.urlScheme, urlScheme)
        
    }
    
    func testWhenGetDescription_GivenURLScheme_ThenDescriptionIsNotEmpty(){
        
        let appClient = ATHMClientApp(urlScheme: "xamarintest")
        
        XCTAssertFalse(appClient.description.isEmpty)
    }

    //MARK:- Negative
    
    func testWhenInitClientApp_GivenEmptyURLScheme_ThenHasANURLSChemeEmpty(){
        
        let client = ATHMClientApp(urlScheme: "   ")
        
        XCTAssertTrue(client.urlScheme.isEmpty)
        
    }
    
    func testWhenGetDescription_GivenEmptyURLScheme_ThenDescriptionIsNotEmpty(){
        
        let appClient = ATHMClientApp(urlScheme: "")
        
        XCTAssertFalse(appClient.description.isEmpty)
    }
    
    //MARK:- Boundary
    
}

