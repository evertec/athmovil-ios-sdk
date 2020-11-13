//
//  URLComponents+GetQueryItemNamed.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

extension URLComponents {
    
    ///Section of the ath movil query
    var itemATHMovil: String { "athm_payment_data" }
    
    
    func getQueryItem(named name: String) -> URLQueryItem? {
        
        guard let queryItems = self.queryItems else { return nil }
        
        for queryItem in queryItems {
            if queryItem.name == name {
                return queryItem
            }
        }
        
        return nil
    }
    
    
    /**
     Checks if the url is from ATH Movil if it is from ath movil it is going to preccess the url and send the reponse to the button handle
     - Parameters:
     - url: Url from the APP delegate it could be from another object
     - Returns: the data from the response if can not get a valid data is going to return nil
     */
    func isATHMovil() -> Data?{
                
        guard let query = self.getQueryItem(named: itemATHMovil),
            let valueResponse = query.value,
            let data = valueResponse.data(using: .utf8) else {
            return nil
        }
        
        return data
    }
}
