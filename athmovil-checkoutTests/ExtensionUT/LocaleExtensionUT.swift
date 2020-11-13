//
//  LocaleUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class LocaleUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenSupportedCodeLanguage_GivenSpanishLanguage_ThenTheCodeIsES(){
        
        let locale = Locale(identifier: "es_ES")
        
        XCTAssertEqual(locale.supportedCodeLang, "es")
    }
    
    func testWhenSupportedCodeLanguage_GivenEnglishLanguage_ThenTheCodeIsEN(){
        
        let locale = Locale(identifier: "en_ING")
        
        XCTAssertEqual(locale.supportedCodeLang, "en")
    }
    
    func testWhenSupportedCodeLanguage_GivenSingletonLocal_ThenGetSupportedLanguage(){
        
        let supportedCode = Locale.current.supportedCodeLang
        
        XCTAssertTrue(supportedCode == "en" || supportedCode == "es")
    }
    
    //MARK:- Negative
    
    func testWhenSupportedCodeLanguage_GivenUnExcpectedLanguage_ThenTheCodeIsEN(){
        
        let locale = Locale(identifier: "fr_TD")
        
        XCTAssertEqual(locale.supportedCodeLang, "en")
    }
    
    //MARK:- Boundary
    
    func testWhenSupportedCodeLanguage_GivenEmptyLanguage_ThenTheCodeIsEN(){
        
        let locale = Locale(identifier: "")
        
        XCTAssertEqual(locale.supportedCodeLang, "en")
    }
    
    func testWhenSupportedCodeLanguage_GivenUpperCaseLanguage_ThenTheCodeIsEN(){
        
        let locale = Locale(identifier: "ES_ESP")
        
        XCTAssertEqual(locale.supportedCodeLang, "es")
    }
    
    
}

