//
//  PostRequestBuilderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

private struct PersonTest: Model {
    let name: String
}

private struct ExceptionModel: Model {
    func encode(to encoder: Encoder) throws {
        throw NSError()
    }
}


class PostRequestBuilderUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenEncodeRequestBody_GivenAnyModel_ThenCanEncodeModelAsData() {
        
        let bodyPerson = PersonTest(name: "Test")
        let postRequest = PostRequestBuilder(baseURL: URL(string: "https//:www.athmovil.com")!,
                                             path: "/test",
                                             body: bodyPerson)
        
        let data = postRequest.encodeRequestBody()
        
        XCTAssertNotNil(data)
    }
    
    
    func testWhenToURLRequest_GivenAPostRequest_ThenGetAGetMethoByDefault() {
        let requestBuilder = Request.post(baseURL: URL(string: "https://www.athmovil.com")!,
                                          path: "/test",
                                          body: PersonTest(name: "test")) { _ in }
                
        XCTAssertEqual(requestBuilder.builder.method, APIPayments.HTTPMethod.post)
    }
    
    func testWhenToURLRequest_GivenAnURLInPostRequest_ThenRequestHasAnURLWithPath() {
        let requestBuilder = Request.post(baseURL: URL(string: "https://www.athmovil.com")!,
                                          path: "/test",
                                          body: PersonTest(name: "test")) { _ in }
        
        
        let request = requestBuilder.builder.toURLRequest()
        
        XCTAssertEqual(request.url!, URL(string: "https://www.athmovil.com/test"))
    }
    
    func testWhenToURLRequest_GivenPostRequest_ThenRequestHasNilQueryParams() {
                
        let requestBuilder = Request.post(baseURL: URL(string: "https://www.athmovil.com")!,
                                          path: "/test",
                                          body: PersonTest(name: "test")) { _ in }
        
        let request = requestBuilder.builder.toURLRequest()
        
        XCTAssertNil(request.url?.query)
    }
    
    func testWhenToURLRequest_GivenPostRequest_ThenURLRequestHasDefaultHeaders() {
        let requestBuilder = Request.post(baseURL: URL(string: "https://www.athmovil.com")!,
                                          path: "/test",
                                          body: PersonTest(name: "test")) { _ in }
        
        let request = requestBuilder.builder.toURLRequest()
        
        XCTAssertNotNil(request.allHTTPHeaderFields?.count)
    }
    
    

    //MARK:- Negative
    
    func testWhenEncodeRequestBody_GivenNilModel_ThenEncodeBodyAsNil() {
        
        let bodyPerson: PersonTest? = nil
        let postRequest = PostRequestBuilder(baseURL: URL(string: "https//:www.athmovil.com")!,
                                             path: "/test",
                                             body: bodyPerson)
        
        let data = postRequest.encodeRequestBody()
        
        XCTAssertNil(data)
    }
    
    //MARK:- Boundary
    
    func testWhenEncodeRequestBody_GivenAnExceptionInModel_ThenEncodeBodyAsNil() {
        
        let bodyException = ExceptionModel()
        let postRequest = PostRequestBuilder(baseURL: URL(string: "https//:www.athmovil.com")!,
                                             path: "/test",
                                             body: bodyException)
        
        let data = postRequest.encodeRequestBody()
        
        XCTAssertNil(data)
    }
    
 
}
