//
//  RequestBuilderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class RequestBuilderUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenToURLRequest_GivenABasicRequest_ThenGetAGetMethoByDefault() {
        let requestBuilder = BasicRequestBuilder.basic(baseURL: URL(string: "https://www.athmovil.com")!,
                                                       path: "/test",
                                                       params: nil) { _ in }
        
        
        let request = requestBuilder.builder.toURLRequest()
        
        XCTAssertEqual(request.httpMethod, APIPayments.HTTPMethod.get.rawValue.uppercased())
    }
    
    func testWhenToURLRequest_GivenAnURL_ThenRequestHasAnURLWithPath() {
        let requestBuilder = BasicRequestBuilder.basic(baseURL: URL(string: "https://www.athmovil.com")!,
                                                       path: "/test",
                                                       params: nil) { _ in }
        
        
        let request = requestBuilder.builder.toURLRequest()
        
        XCTAssertEqual(request.url!, URL(string: "https://www.athmovil.com/test"))
    }
    
    func testWhenToURLRequest_GivenQueryItem_ThenRequestHasQueryParams() {
        
        let queryItem = URLQueryItem(name: "name", value: "test")
        
        let requestBuilder = BasicRequestBuilder.basic(baseURL: URL(string: "https://www.athmovil.com")!,
                                                       path: "/test",
                                                       params: [queryItem]) { _ in }
        
        let request = requestBuilder.builder.toURLRequest()
        
        XCTAssertEqual(request.url?.query, "name=test")
    }
    
    func testWhenToURLRequest_GivenBasicRequest_ThenURLRequestHasDefaultHeaders() {
        let requestBuilder = BasicRequestBuilder.basic(baseURL: URL(string: "https://www.athmovil.com")!,
                                                       path: "/test",
                                                       params: nil) { _ in }
        
        let request = requestBuilder.builder.toURLRequest()
        
        XCTAssertNotNil(request.allHTTPHeaderFields?.count)
    }
    
}
