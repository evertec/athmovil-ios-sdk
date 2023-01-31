//
//  UserPreferences.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/12/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import Foundation
import athmovil_checkout

class UserPreferences: NSObject, NSCoding {
    static var shared = UserPreferences.read()
    // CONFIGURATION
    var publicToken = "e7d8056974085111e695b5f7a99d27c206a73089"
    var timeOut = 600.0
    var paymentAmount = 1.0
    var theme = 0
    var enviroment = "Production"
    var newFlow = "NO"
    
    // OPTIONAL PARAMETERS
    var subTotal = 0.0
    var tax = 0.0
    var metadata1 = ""
    var metadata2 = ""
    var items: [ATHMPaymentItem] = []
    var phoneNumber = ""
    
    let themeList: [String] = [ATHMThemeClassic.name, ATHMThemeLight.name, ATHMThemeNight.name]
    let enviroments: [String] =  ["Quality", "Pilot", "Production"]
    let isNewFlow: [String] =  ["NO", "SI"]
        
    fileprivate override init() {
        super.init()
        self.save()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(publicToken, forKey: "publicToken")
        aCoder.encode(timeOut, forKey: "timeOut")
        aCoder.encode(paymentAmount, forKey: "paymentAmount")
        aCoder.encode(theme, forKey: "themeIndex")
        aCoder.encode(enviroment, forKey: "enviroment")
        
        aCoder.encode(subTotal, forKey: "subTotal")
        aCoder.encode(tax, forKey: "tax")
        aCoder.encode(metadata1, forKey: "metadata1")
        aCoder.encode(metadata2, forKey: "metadata2")
        aCoder.encode(items, forKey: "items")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        publicToken = aDecoder.decodeObject(forKey: "publicToken") as? String ?? ""
        timeOut = aDecoder.decodeDouble(forKey: "timeOut")
        paymentAmount = aDecoder.decodeDouble(forKey: "paymentAmount")
        theme = aDecoder.decodeInteger(forKey: "themeIndex")
        enviroment = (aDecoder.decodeObject(forKey: "enviroment") as? String) ?? "Production"
        
        subTotal = aDecoder.decodeDouble(forKey: "subTotal")
        tax = aDecoder.decodeDouble(forKey: "tax")
        metadata1 = aDecoder.decodeObject(forKey: "metadata1") as? String ?? ""
        metadata2 = aDecoder.decodeObject(forKey: "metadata2") as? String ?? ""
        items = aDecoder.decodeObject(forKey: "items") as? [ATHMPaymentItem] ?? []
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
    }
}

extension UserPreferences {
    static func reset() {
        shared = UserPreferences()
        shared.save()
    }
    
    func save(){
        if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) {
            UserDefaults.standard.set(encodedData, forKey: "settings")
        }
    }
    
    fileprivate static func read() -> UserPreferences {
        if let data = UserDefaults.standard.data(forKey: "settings"),
            let settings = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) {
            return (settings as! UserPreferences)
        }
        return UserPreferences()
    }
}

fileprivate extension ATHMThemeClassic {
    static var name: String { "Classic" }
}

fileprivate extension ATHMThemeLight {
    static var name: String { "Light" }
}

fileprivate extension ATHMThemeNight {
    static var name: String { "Dark" }
}

extension UserPreferences {
    
    public var nameTheme: String { getThemeName(index: theme) }
        
    func getThemeName(index: Int) -> String{
        switch index {
            case 0:
                return ATHMThemeClassic.name
            case 1:
                return ATHMThemeLight.name
            case 2:
                return ATHMThemeNight.name
            default:
                return ""
        }
    }
}


extension ATHMPaymentItem: NSCoding {
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(price.doubleValue, forKey: "price")
        coder.encode(quantity, forKey: "quantity")
        coder.encode(desc, forKey: "desc")
        coder.encode(metadata, forKey: "metadata")
    }
    
    public convenience init(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as? String
        let price = coder.decodeDouble(forKey: "price")
        let quantity = coder.decodeInteger(forKey: "quantity")
        let metadata = coder.decodeObject(forKey: "metadata") as? String
        let desc = coder.decodeObject(forKey: "desc") as? String
        
        self.init(name: name ?? "", price: NSNumber(value: price), quantity: quantity)
        self.desc = desc ?? ""
        self.metadata = metadata ?? ""
    }
}
