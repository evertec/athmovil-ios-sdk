//
//  ATHMButtonUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMButtonUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenCreateButton_GivenDefaultConstructor_ThenButtonHasClassicTheme(){
        
        let button = ATHMButton()
        
        XCTAssertNotNil(button.theme as? ATHMThemeClassic)
    }
    
    
    func testWhenCreateButton_GivenFrameConstructor_ThenButtonHasClassicTheme(){
        
        let button = ATHMButton(frame: .zero)
        
        XCTAssertNotNil(button.theme as? ATHMThemeClassic)
    }
    
    
    func testWhenSetTheme_GivenNightTheme_ThenSetBackgroundColor(){
        
        let button = ATHMButton()
        
        button.theme = ATHMThemeNight()
        
        XCTAssertEqual(button.backgroundColor, button.theme.background)
    }
    
    func testWhenSetTheme_GivenNightTheme_ThenSetTintColor(){
        
        let button = ATHMButton()
        
        button.theme = ATHMThemeNight()
        
        XCTAssertEqual(button.tintColor, button.theme.tintColor)
    }
    
    func testWhenSetTheme_GivenNightTheme_ThenImage(){
        
        let button = ATHMButton()
        
        button.theme = ATHMThemeNight()
        
        XCTAssertEqual(button.imageView?.image, button.theme.image)
    }
    
    //MARK:- Negative
    
    //MARK:- Boundary
    
    func testWhenToggleLight_GivenUIKitButton_ThenButtonChangeTintColor(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeLight()
        
        genericButton.toggleATHMLight()
        
        XCTAssertEqual(genericButton.tintColor, theme.tintColor)
    }
    
    func testWhenToggleLight_GivenUIKitButton_ThenButtonChangeBackGroundColor(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeLight()
        
        genericButton.toggleATHMLight()
        
        XCTAssertEqual(genericButton.backgroundColor, theme.background)
    }
    
    func testWhenToggleLight_GivenUIKitButton_ThenButtonChangeImage(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeLight()
        
        genericButton.toggleATHMLight()
        
        XCTAssertEqual(genericButton.imageView?.image, theme.image)
    }
    
    
    func testWhenToggleNight_GivenUIKitButton_ThenButtonChangeTintColor(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeNight()
        
        genericButton.toggleATHMNight()
        
        XCTAssertEqual(genericButton.tintColor, theme.tintColor)
    }
    
    func testWhenToggleNight_GivenUIKitButton_ThenButtonChangeBackGroundColor(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeNight()
        
        genericButton.toggleATHMNight()
        
        XCTAssertEqual(genericButton.backgroundColor, theme.background)
    }
    
    func testWhenToggleNight_GivenUIKitButton_ThenButtonChangeImage(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeNight()
        
        genericButton.toggleATHMNight()
        
        XCTAssertEqual(genericButton.imageView?.image, theme.image)
    }
    
    func testWhenToggleClassic_GivenUIKitButton_ThenButtonChangeTintColor(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeClassic()
        
        genericButton.toggleATHMClassic()
        
        XCTAssertEqual(genericButton.tintColor, theme.tintColor)
    }
    
    func testWhenToggleClassic_GivenUIKitButton_ThenButtonChangeBackGroundColor(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeClassic()
        
        genericButton.toggleATHMClassic()
        
        XCTAssertEqual(genericButton.backgroundColor, theme.background)
    }
    
    func testWhenToggleClassic_GivenUIKitButton_ThenButtonChangeImage(){
        
        let genericButton = UIButton()
        let theme = ATHMThemeClassic()
        
        genericButton.toggleATHMClassic()
        
        XCTAssertEqual(genericButton.imageView?.image, theme.image)
    }
    
    
    func testWhenToggle_GivenNewTheme_ThenChangeBackgroundIsGreen(){
        
        let genericButton = UIButton()
        genericButton.toggle(theme: ThemeTest())
        
        XCTAssertEqual(genericButton.backgroundColor, .green)
        
    }
    
    func testWhenToggle_GivenNewTheme_ThenButtonTintIsGreen(){
        
        let genericButton = UIButton()
        
        genericButton.toggle(theme: ThemeTest())
        
        XCTAssertEqual(genericButton.tintColor, .green)
        
    }
    
    func testWhenToggle_GivenNewTheme_ThenImageIsNil(){
        
        let genericButton = UIButton()
        
        genericButton.toggle(theme: ThemeTest())
        
        XCTAssertNil(genericButton.imageView?.image)
        
    }
    
}


class ThemeTest: ATHMPaymentTheme{
    ///Color for the control, orange
    var background: UIColor { .green }
    
    ///Color for the label, white
    var tintColor: UIColor { .green }
    
    ///Image for the control by default white_checkout_button_en
    var image: UIImage? = nil
}


