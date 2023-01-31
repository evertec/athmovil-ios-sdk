//
//  UserPreferences.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/12/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import Foundation

class UserPreferences: NSObject {
    
    static var shared = UserPreferences.read()
    var authToken = ""
        
    fileprivate override init() {
        super.init()
        self.save()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(authToken, forKey: "authToken")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        authToken = aDecoder.decodeObject(forKey: "authToken") as? String ?? ""
    }
}

extension UserPreferences {
    static func reset() {
        shared = UserPreferences()
        shared.save()
    }
    
    func save(){
        if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) {
            UserDefaults.standard.set(encodedData, forKey: "athm_checkout")
        }
    }
    
    fileprivate static func read() -> UserPreferences {
        if let data = UserDefaults.standard.data(forKey: "athm_checkout"),
            let settings = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) {
            return (settings as! UserPreferences)
        }
        return UserPreferences()
    }
}
