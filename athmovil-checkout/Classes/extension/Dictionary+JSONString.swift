//
//  Dictionary+JSONString.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

extension Dictionary {
    var toJSONString: String? {
        
        guard let data = try? JSONSerialization.data(
            withJSONObject: self,
            options: .prettyPrinted)
            else { return nil }
        
        let jsonString = String(data: data, encoding:
            String.Encoding.utf8)
        
        return jsonString
    }
}
