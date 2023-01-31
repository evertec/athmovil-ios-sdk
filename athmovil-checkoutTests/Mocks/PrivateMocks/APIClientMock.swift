//
//  APIClientMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct APIClientMock: APIClientRequestable {
    
    let response: Data?
    let networkError: NetworkError?
    var session: URLSession = URLSession.shared
    var dispatchQueue: DispatchQueue = DispatchQueue.global()
    
    init(response: Data? = nil, error: NetworkError? = nil) {
        self.response = response
        self.networkError = error
    }
    
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
