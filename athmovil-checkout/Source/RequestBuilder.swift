//
//  RequestBuilder.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

protocol RequestBuilder {
    var method: APIPayments.HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var params: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    
    func toURLRequest() -> URLRequest
    
    func encodeRequestBody() -> Data?
}

struct BasicRequestBuilder: RequestBuilder {
    var method: APIPayments.HTTPMethod
    var baseURL: URL
    var path: String
    var params: [URLQueryItem]?
    var headers: [String: String]?
}

extension RequestBuilder {
    
    func encodeRequestBody() -> Data? { nil }
    
    public func toURLRequest() -> URLRequest {
        
        let fullURL = baseURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: fullURL, resolvingAgainstBaseURL: false)!
        
        urlComponents.queryItems = params
        let urlFromComponents = urlComponents.url!
        var urlRequest = URLRequest(url: urlFromComponents)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue.uppercased()
        urlRequest.httpBody = encodeRequestBody()
        
        return urlRequest
    }
    
    public static func basic(method: APIPayments.HTTPMethod = .get,
                             baseURL: URL,
                             path: String,
                             params: [URLQueryItem]? = nil,
                             completion: @escaping (Result<Data, NetworkError>) -> Void) -> Request {
        
        let builder = BasicRequestBuilder(method: method,
                                          baseURL: baseURL,
                                          path: path,
                                          params: params)
        
        return Request(builder: builder, completion: completion)
    }
}

struct Request {
    
    let builder: RequestBuilder
    let completion: (Result<Data, NetworkError>) -> Void
    
    init(builder: RequestBuilder, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        self.builder = builder
        self.completion = completion
    }
}

extension Request {
    
    static func post<Body:Model>(baseURL: URL,
                                  path: String,
                                  body: Body?,
                                  headers: [String : String]? = [:],
                                  completion: @escaping (Result<Data, NetworkError>) -> Void) -> Request {
        
        let builder = PostRequestBuilder(baseURL: baseURL,
                                         path: path,
                                         params: nil,
                                         body: body,
                                         headers: headers)
        return Request(builder: builder, completion: completion)
    }
}
