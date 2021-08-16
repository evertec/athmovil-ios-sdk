//
//  NetworkErrorUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class NetworkErrorUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenGetError_GivenHTTPCode200_ThenTheErrorIsNil() {
        
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.athmovil.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        let error = NetworkError.error(from: urlResponse)
        
        XCTAssertNil(error)
    }
    
    //MARK:- Negative
    
    func testWhenGetError_GivenHTTPCode405_ThenErrorIsRequestError() {
        
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.athmovil.com")!,
                                          statusCode: 405,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        let error = NetworkError.error(from: urlResponse)
        
        switch error {
            case .requestError:
                XCTAssert(true)
            default:
                XCTAssert(false)
        }
    }
    
    func testWhenGetError_GivenHTTPCode505_ThenErrorIsServerError() {
        
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.athmovil.com")!,
                                          statusCode: 505,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        let error = NetworkError.error(from: urlResponse)
        
        switch error {
            case .serverError:
                XCTAssert(true)
            default:
                XCTAssert(false)
        }
    }
    
    //MARK:- Boundary
    
    func testWhenGetError_GivenHTTPCode100_ThenErrorIsHandlerError() {
        
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.athmovil.com")!,
                                          statusCode: 100,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        let error = NetworkError.error(from: urlResponse)
        
        switch error {
            case .unHandledResponse:
                XCTAssert(true)
            default:
                XCTAssert(false)
        }
    }
    
    func testWhenGetError_GivenAInstanceDifferenteToHTTPURLResponse_ThenErrorIsUnkowedResponser() {
        
        let urlResponseNil = URLResponse(url: URL(string: "https://www.athmovil.com")!,
                                         mimeType: nil,
                                         expectedContentLength: 0,
                                         textEncodingName: nil)
        
        let error = NetworkError.error(from: urlResponseNil)
        
        switch error {
            case .unkowedResponse:
                XCTAssert(true)
            default:
                XCTAssert(false)
        }
    }
}
