//
//  URLComponents+GetQueryItemNamed.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

extension URLComponents {
    func getQueryItem(named name: String) -> URLQueryItem? {
        
        guard let queryItems = self.queryItems else { return nil }
        
        for queryItem in queryItems {
            if queryItem.name == name {
                return queryItem
            }
        }
        
        return nil
    }
}
