//
//  NSDictionary.swift
//  athmovil-checkout
//
//  Created by Hansy on 11/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    /// Subscript for getting the value for the key if the key does not exist or is empty wil return an empty string
    subscript(key: String) -> String {
        
        guard let value = value(forKey: key) as? String else {
            return ""
        }
        
        return value.trimmingCharacters(in: .whitespaces)
    }
    
    /// Subscript for getting a NSNumber from the dictionary if the key does not exist or is empty will return a zero
    subscript(key: String) -> NSNumber {
        let valueObject = object(forKey: key)
        
        if let valueString = valueObject as? String, let doubleValue = Double(valueString) {
            return NSNumber(value: doubleValue)
        }
        
        if let valueNumber = valueObject as? NSNumber {
            return valueNumber
        }
        
        return NSNumber(value: 0)
    }
    
    /// Subscript for getting the array from the key parameter
    subscript(key: String) -> [NSDictionary] {
        
        guard let value = value(forKey: key) as? [NSDictionary] else {
            return [NSDictionary]()
        }
        
        return value
    }
    
    /// Subscript for getting an integer from the dictionary
    subscript(key: String) -> Int {
        
        let valueDic = value(forKey: key)
        
        if let valueString = valueDic as? String, let intValue = Int(valueString) {
            return intValue
        }
        
        if let value = valueDic as? Int {
            return value
        }
        
        return 0
    }
    
    /// Subscript for getting an double from the dictionary
    subscript(key: String) -> Double {
        
        let valueDic = value(forKey: key)
        
        if let valueString = valueDic as? String, let doubleValue = Double(valueString) {
            return doubleValue
        }
        
        if let value = valueDic as? Double {
            return value
        }
        
        return 0.0
    }
}
