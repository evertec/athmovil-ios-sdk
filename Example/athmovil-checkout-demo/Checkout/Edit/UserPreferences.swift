//
//  UserPreferences.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/12/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import Foundation

class UserPreferences: NSObject, NSCoding {
    static var shared = UserPreferences.read()
    // CONFIGURATION
    var publicToken = "fb1f7ae2849a07da1545a89d997d8a435a5f21ac"
    var timeOut = 600.0
    var paymentAmount = 1.0
    var theme = 0
    
    // OPTIONAL PARAMETERS
    var subTotal = 0.0
    var tax = 0.0
    var metadata1 = ""
    var metadata2 = ""
    
    fileprivate override init() {
        super.init()
        self.save()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(publicToken, forKey: "publicToken")
        aCoder.encode(timeOut, forKey: "timeOut")
        aCoder.encode(paymentAmount, forKey: "paymentAmount")
        aCoder.encode(theme, forKey: "themeIndex")
        
        aCoder.encode(subTotal, forKey: "subTotal")
        aCoder.encode(tax, forKey: "tax")
        aCoder.encode(metadata1, forKey: "metadata1")
        aCoder.encode(metadata2, forKey: "metadata2")
    }
    
    required init?(coder aDecoder: NSCoder) {
        publicToken = aDecoder.decodeObject(forKey: "publicToken") as? String ?? ""
        timeOut = aDecoder.decodeDouble(forKey: "timeOut")
        paymentAmount = aDecoder.decodeDouble(forKey: "paymentAmount")
        theme = aDecoder.decodeInteger(forKey: "themeIndex")
        
        subTotal = aDecoder.decodeDouble(forKey: "subTotal")
        tax = aDecoder.decodeDouble(forKey: "tax")
        metadata1 = aDecoder.decodeObject(forKey: "metadata1") as? String ?? ""
        metadata2 = aDecoder.decodeObject(forKey: "metadata2") as? String ?? ""
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


extension UserPreferences{
    
    public var nameTheme: String{
        return self.getName(index: self.theme)
    }
    
    func getName(index: Int) -> String{
        switch index {
            case 0:
            return "Original"
            case 1:
            return "Light"
            case 2:
            return "Dark"
            default:
            return ""
        }
    }
    
}
