//
//  PostRequestBuilder.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

struct PostRequestBuilder<Body: Model>: RequestBuilder {
    let method: APIPayments.HTTPMethod
    let baseURL: URL
    let path: String
    let params: [URLQueryItem]?
    let headers: [String : String] = [:]
    let body: Body?
    
    public init(baseURL: URL,
                path: String,
                params: [URLQueryItem]? = nil,
                body: Body? = nil) {
        
        self.method = .post
        self.baseURL = baseURL
        self.path = path
        self.params = params
        self.body = body
    }
    
    func encodeRequestBody() -> Data? {
        
        guard let bodyEncode = body else {
            return nil
        }
        
        do {
            return try Body.encoder.encode(bodyEncode)
        } catch {
            return nil
        }
    }
}
