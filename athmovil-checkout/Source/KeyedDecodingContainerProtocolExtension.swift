//
//  KeyDecodingExtension.swift
//  athm-checkout
//
//  Created by Hansy Enrique on 6/12/20.
//  Copyright © 2020 Evertec, Inc. All rights reserved.
//

import Foundation


extension KeyedDecodingContainerProtocol{
    
    func decodeValueDefault(forKey key: Self.Key) -> Double{
        let value = try? decodeIfPresent(Double.self, forKey: key) ?? 0.0
        return value ?? 0.0
    }
    
    func decodeValueDefault(forKey key: Self.Key) -> String{
        let value = try? decodeIfPresent(String.self, forKey: key) ?? ""
        return value ?? ""
    }
    
    func decodeValueDefault(forKey key: Self.Key) -> Int{
        let value = try? decodeIfPresent(Int.self, forKey: key) ?? 0
        return value ?? 0
    }
    
    func decodeValueDefault(forKey key: Self.Key) -> ATHMStatus{
        let value = try? decodeIfPresent(ATHMStatus.self, forKey: key) ?? .cancelled
        return value ?? .cancelled
    }
    
    func decodeValueDefault(forKey key: Self.Key) -> Bool{
        let value = try? decodeIfPresent(Bool.self, forKey: key) ?? false
        return value ?? false
    }
    
    func decodeValueDefault(forKey key: Self.Key) -> Date{
        let value = try? decodeIfPresent(Date.self, forKey: key) ?? Date()
        return value ?? Date()
    }

}

