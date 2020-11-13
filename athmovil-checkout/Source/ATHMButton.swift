//
//  ATHMButton.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/20/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@IBDesignable @objc(ATHMButton)
public class ATHMButton: UIButton{

    ///Update the theme of the button change theme night, light or classic furthermore set the backgound, tint color, corner radious and image
     public var theme: ATHMPaymentTheme = ATHMThemeClassic()
     {
        didSet{
            toggle(theme: self.theme)
        }
    }
    
    init(){
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


extension UIButton{
    
    func toggle<T:ATHMPaymentTheme>(theme: T){
        
        self.setImage(theme.image, for: .normal)
        self.backgroundColor = theme.background
        self.tintColor = theme.tintColor
        
        adjustImage()
        
        setShadowAndRadious()
    }
    
    func adjustImage(){
        self.imageView?.contentMode = .scaleAspectFit
        let separator = (self.frame.width * 0.50) / 2.0
        self.imageEdgeInsets = UIEdgeInsets(top: 8, left: separator, bottom: 8, right: separator)
    }
    
    func setShadowAndRadious() {
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue:0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
}

@objc(ATHMovilButtonTheme)
public extension UIButton{
    
    @objc func toggleATHMNight(){
        self.toggle(theme: ATHMThemeNight())
    }

    @objc func toggleATHMLight(){
        self.toggle(theme: ATHMThemeLight())
    }

    @objc func toggleATHMClassic(){
        self.toggle(theme: ATHMThemeClassic())
    }
    
}
