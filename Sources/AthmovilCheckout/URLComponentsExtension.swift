//
//  URLComponents+GetQueryItemNamed.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

private extension URLComponents {
        
    func getQueryItem(named name: String) -> URLQueryItem? {
        
        guard let queryItems = queryItems else { return nil }
        
        for queryItem in queryItems where queryItem.name == name {
            return queryItem
        }
        
        return nil
    }
}

extension URL {
    
    /// Use a URL Components to vaidate if the current URL is a valid response from ATH Movil
    var responseFromATHM: Data? {
        
        let athMovilParamaterName = "athm_payment_data"
        
        guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let responseValue = urlComponents.getQueryItem(named: athMovilParamaterName)?.value,
              let dataFromATHM = responseValue.data(using: .utf8) else {
            return nil
        }
        return dataFromATHM
    }
}
