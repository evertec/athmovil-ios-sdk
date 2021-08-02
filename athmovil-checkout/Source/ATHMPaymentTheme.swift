//
//  ATHPurchaseTheme.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentTheme)
public protocol ATHMPaymentTheme {

    /// Color for the control
    @objc var background: UIColor { get }
    
    /// Color for the label
    @objc var tintColor: UIColor { get }
    
    /// Image for the control
    @objc var image: UIImage? { get }
}

@objc(ATHThemeClassic)
public final class ATHMThemeClassic: NSObject, ATHMPaymentTheme {
    
    /// Color for the control, orange
    public var background: UIColor { .orange }
    
    /// Color for the label, white
    public var tintColor: UIColor { .white }
    
    /// Image for the control by default white_checkout_button_en
    public private(set) var image: UIImage?
    
    /// Init by default to create the image requested
    required public override init() {
        super.init()
        
        let bundle = Bundle(for: self.classForCoder)
        let codeLanguage = Locale.current.supportedCodeLang
        
        self.image = UIImage(named: "white_checkout_button_\(codeLanguage)", in: bundle, compatibleWith: nil)
    }
}

@objc(ATHThemeLight)
public final class ATHMThemeLight: NSObject, ATHMPaymentTheme {
    
    /// Color for the control, white
    public var background: UIColor { .white }
    
    /// Color for the label, black
    public var tintColor: UIColor { .black }
    
    /// Image for the control by default black_checkout_button_en
    public private(set) var image: UIImage?
    
    /// Init by default to create the image requested
    required override public init() {
        super.init()
        
        let bundle = Bundle(for: self.classForCoder)
        let codeLanguage = Locale.current.supportedCodeLang
        
        self.image = UIImage(named: "black_checkout_button_\(codeLanguage)", in: bundle, compatibleWith: nil)
    }
    
}

@objc(ATHThemeNight)
public class ATHMThemeNight: NSObject, ATHMPaymentTheme {
    
    /// Color for the control, darkGray
    public var background: UIColor { .darkGray }
    
    /// Color for the label, white
    public var tintColor: UIColor { .white }
    
    /// Image for the control by default black_checkout_button_en
    public private(set) var image: UIImage?
    
    /// Contructor by default to create the image requested
    required override public init() {
        super.init()
        
        let bundle = Bundle(for: self.classForCoder)
        let codeLanguage = Locale.current.supportedCodeLang
        
        self.image = UIImage(named: "white_checkout_button_\(codeLanguage)", in: bundle, compatibleWith: nil)
    }
}
