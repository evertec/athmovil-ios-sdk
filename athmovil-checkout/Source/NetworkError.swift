//
//  NetworkError.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    /// If our response is not an urlresponse
    case unkowedResponse
    
    /// Network error timeout, offline, etc
    case netWorkError
    
    /// Error for http codes 4xx
    case requestError(Int)
    
    /// Error for http codes 5xx
    case serverError(Int)
    
    /// Case when we can not decoding a object
    case decodingError(DecodingError)
    
    /// Catch somenthing that we must handle
    case unHandledResponse
}

extension NetworkError {
    
    static func error(from response: URLResponse?) -> NetworkError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkError.unkowedResponse
        }
        
        switch httpResponse.statusCode {
            case 200...299:
                return nil
                
            case 400...499:
                return .requestError(httpResponse.statusCode)
                
            case 500...599:
                return .serverError(httpResponse.statusCode)
                
            default:
                return .unHandledResponse
        }
    }
}
