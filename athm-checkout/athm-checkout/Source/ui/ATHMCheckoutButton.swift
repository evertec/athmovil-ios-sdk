//
//  AMCheckoutButton.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

@objc public class ATHMCheckoutButton: UIButton {
    
    // MARK: Properties
    
    @objc public var lang: AMLanguage = .deviceLanguage {
        didSet {
            setStyle()
        }
    }
    
    @objc public var style: AMCheckoutButtonStyle = .original {
        didSet {
            setStyle()
        }
    }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    fileprivate func setImageButton() {
        let bundle = Bundle(for: type(of: self))
        if let buttonImage = style.image(bundle: bundle, lang) {
            setImage(buttonImage, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            imageView?.contentMode = .scaleAspectFit
            adjustsImageWhenHighlighted = false
        }
    }
    
    fileprivate func setShadowAndRadious() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue:
            0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
        layer.cornerRadius = 4.0
    }
    
    fileprivate func setStyle() {
        setImageButton()
        setShadowAndRadious()
        backgroundColor = style.bgColor
        tintColor = style.textColor
    }
    
    @objc public func fitToSuperview() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options:
            .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options:
            .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
