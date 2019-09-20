//
//  String+JSON.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

extension String {
    var toJSON: [String: Any]? {
        
        guard let query = self.removingPercentEncoding else { return nil }
        
        guard let data = query.data(using: .utf8) else { return nil }
        
        guard let json = try? JSONSerialization.jsonObject( with: data, options: .mutableContainers)
            as? [String: Any] else { return nil }
        
        return json
    }
}
