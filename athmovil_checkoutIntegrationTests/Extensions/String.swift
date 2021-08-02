//
//  String.swift
//  athmovil_checkoutIntegrationTests
//
//  Created by Hansy on 12/22/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

extension String{
    
    var toData: Data? {
        
        guard let query = self.removingPercentEncoding else { return nil }
        
        guard let data = query.data(using: .utf8) else { return nil }
        
        return data
    }
    
    var toJSON: [String: Any]? {
        
        guard let query = self.removingPercentEncoding else { return nil }
        
        guard let data = query.data(using: .utf8) else { return nil }
        
        guard let json = try? JSONSerialization.jsonObject( with: data, options: .mutableContainers)
                as? [String: Any] else { return nil }
        
        return json
    }
}

