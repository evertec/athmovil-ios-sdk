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
    var paymentAmount = 111.5
    var theme = 0
    // OPTIONAL PARAMETERS
    var subTotalIsOn = true
    var taxIsOn = true
    var metadata1IsOn = true
    var metadata2IsOn = true
    var itemsIsOn = true
    
    fileprivate override init() {
        super.init()
        self.save()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(publicToken, forKey: "publicToken")
        aCoder.encode(timeOut, forKey: "timeOut")
        aCoder.encode(paymentAmount, forKey: "paymentAmount")
        aCoder.encode(theme, forKey: "themeIndex")
        
        aCoder.encode(subTotalIsOn, forKey: "subTotalIsOn")
        aCoder.encode(taxIsOn, forKey: "taxIsOn")
        aCoder.encode(metadata1IsOn, forKey: "metadata1IsOn")
        aCoder.encode(metadata2IsOn, forKey: "metadata2IsOn")
        aCoder.encode(itemsIsOn, forKey: "itemsIsOn")
    }
    
    required init?(coder aDecoder: NSCoder) {
        publicToken = aDecoder.decodeObject(forKey: "publicToken") as? String ?? ""
        timeOut = aDecoder.decodeDouble(forKey: "timeOut")
        paymentAmount = aDecoder.decodeDouble(forKey: "paymentAmount")
        theme = aDecoder.decodeInteger(forKey: "themeIndex")
        
        subTotalIsOn = aDecoder.decodeBool(forKey: "subTotalIsOn")
        taxIsOn = aDecoder.decodeBool(forKey: "taxIsOn")
        metadata1IsOn = aDecoder.decodeBool(forKey: "metadata1IsOn")
        metadata2IsOn = aDecoder.decodeBool(forKey: "metadata2IsOn")
        itemsIsOn = aDecoder.decodeBool(forKey: "itemsIsOn")
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
