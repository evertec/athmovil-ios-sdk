//
//  ATHMThemeUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import athmovil_checkout

class ATHMThemeUT: XCTestCase {
    
    
    //MARK:- Positive
    
    
    func testWhenCreateTheme_GivenNightTheme_ThenNightThemeHasImage() {
        
        let themeNight = ATHMThemeNight()
        
        XCTAssertNotNil(themeNight.image)
    }
    
    func testWhenCreateTheme_GivenNightTheme_ThenNightThemeHasTintColor() {
        
        let themeNight = ATHMThemeNight()
        
        XCTAssertEqual(themeNight.tintColor, .white)
    }
    
    func testWhenCreateTheme_GivenNightTheme_ThenNightThemeHasBackgroundColor() {
        
        let themeNight = ATHMThemeNight()
        
        XCTAssertEqual(themeNight.background, .darkGray)
    }
    
    
    func testWhenCreateTheme_GivenLightTheme_ThenLightThemeHasImage() {
        
        let themeNight = ATHMThemeLight()
        
        XCTAssertNotNil(themeNight.image)
    }
    
    func testWhenCreateTheme_GivenLightTheme_ThenLightThemeHasTintColor() {
        
        let themeNight = ATHMThemeLight()
        
        XCTAssertEqual(themeNight.tintColor, .black)
    }
    
    func testWhenCreateTheme_GivenLightTheme_ThenLightThemeHasBackgroundColor() {
        
        let themeNight = ATHMThemeLight()
        
        XCTAssertEqual(themeNight.background, .white)
    }
    
    func testWhenCreateTheme_GivenClassicTheme_ThenClassicThemeHasImage() {
        
        let themeNight = ATHMThemeClassic()
        
        XCTAssertNotNil(themeNight.image)
    }
    
    func testWhenCreateTheme_GivenClassicTheme_ThenClassicThemeHasTintColor() {
        
        let themeNight = ATHMThemeClassic()
        
        XCTAssertEqual(themeNight.tintColor, .white)
    }
    
    func testWhenCreateTheme_GivenClassicTheme_ThenClassicThemeHasBackgroundColor() {
        
        let themeNight = ATHMThemeClassic()
        
        XCTAssertEqual(themeNight.background, .orange)
    }
    
    
    //MARK:- Negative
    
    
    //MARK:- Boundary
    
    
    
}
