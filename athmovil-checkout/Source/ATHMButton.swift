//
//  ATHMButton.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/20/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@IBDesignable @objc(ATHMButton)
public class ATHMButton: UIButton {

    /// Update the theme of the button change theme night, light or classic furthermore set the backgound, tint color, corner radious and image
     public var theme: ATHMPaymentTheme = ATHMThemeClassic() {
        didSet {
            toggle(theme: self.theme)
        }
     }
    
    init() {
        super.init(frame: .zero)
    }

    @objc public dynamic required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.theme = ATHMThemeClassic()
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)

        theme = ATHMThemeClassic()
    }
}

extension UIButton {
    
    func toggle<T:ATHMPaymentTheme>(theme: T) {
        
        setImage(theme.image, for: .normal)
        backgroundColor = theme.background
        tintColor = theme.tintColor
        
        adjustImage()
        
        setShadowAndRadious()
    }
    
    func adjustImage() {
        imageView?.contentMode = .scaleAspectFit
        let separator = (frame.width * 0.50) / 2.0
        imageEdgeInsets = UIEdgeInsets(top: 8, left: separator, bottom: 8, right: separator)
    }
    
    func setShadowAndRadious() {
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue:0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
        layer.cornerRadius = 4.0
    }
}

@objc(ATHMovilButtonTheme)
public extension UIButton {
    
    @objc func toggleATHMNight() {
        toggle(theme: ATHMThemeNight())
    }

    @objc func toggleATHMLight() {
        toggle(theme: ATHMThemeLight())
    }

    @objc func toggleATHMClassic() {
        toggle(theme: ATHMThemeClassic())
    }
    
}
