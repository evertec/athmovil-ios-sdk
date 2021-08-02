//
//  Locale.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

extension Locale {
    
    var supportedCodeLang: String {
        
        let currentCode = languageCode?.lowercased() ?? "en"
        
        switch currentCode {
            case "es":
                return currentCode
            case "en":
                return currentCode
            default:
                return "en"
        }
    }
    
}
