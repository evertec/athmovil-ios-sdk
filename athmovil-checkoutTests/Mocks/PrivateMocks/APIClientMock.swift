//
//  APIClientMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct APIClientMocK: APIClientRequestable {
    
    let response: Data?
    let networkError: NetworkError?
    
    func send(request: Request) {
        
        if let errorCustom = networkError {
            request.completion(.failure(errorCustom))
            return
        }
        
        if let responseData = response {
            request.completion(.success(responseData))
        }
    }
}
