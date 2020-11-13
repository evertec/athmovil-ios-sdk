//
//  ATHMPaymentHandlerDictionaryUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 9/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentHandlerDictionaryUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenConfirmTransaction_GivenStatusCompleted_ThenCompletedClosureIsCalled(){
        
        let responseMock = getMockDate(key: "status", value: "completed")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { (response: NSDictionary) in
            XCTAssertEqual(response, responseMock)
        }, onExpired: { (_) in
            XCTAssert(false)
        }, onCancelled: { (_) in
            XCTAssert(false)
        }) { (_) in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    func testWhenConfirmTransaction_GivenStatusExpired_ThenExpiredClosureIsCalled(){
        
        let responseMock = getMockDate(key: "status", value: "expired")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response: NSDictionary) in
            XCTAssertEqual(response, responseMock)
        }, onCancelled: { _ in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    func testWhenConfirmTransaction_GivenStatusCancelled_ThenCancelledClosureIsCalled(){
        
        let responseMock = getMockDate(key: "status", value: "cancelled")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssertEqual(response, responseMock)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    //MARK:- Negative
    
    func testWhenConfirmTransaction_GivenEmptyStatus_ThenCancelledClosureAsDefault(){
        
        let responseMock = getMockDate(key: "status", value: "")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssertEqual(response, responseMock)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    //MARK:- Boundary
    
    func testWhenConfirmTransaction_GivenUnexpectedStatus_ThenCancelledClosureAsDefault(){
        
        let responseMock = getMockDate(key: "status", value: "hello")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssertEqual(response, responseMock)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
        
    func testWhenConfirmTransaction_GivenEmptyResponse_ThenExceptionClasureIsCalled(){
        
        let responseMock = NSMutableDictionary(dictionary: getMockDate(key: "status", value: "test"))
        responseMock.removeAllObjects()
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(true)
        }
        
        handler.confirm(from: data)
    }
    
    //Mark:- MockData
    
    func getMockDate(key: String, value: Any) -> NSDictionary{
        
        var response: [String: Any] = ["name": "test",
                                        "phoneNumber": "1234567890",
                                        "metadata1": "",
                                        "tax": 0,
                                        "version": "3.0",
                                        "total": 1,
                                        "referenceNumber": "",
                                        "subtotal": 0,
                                        "metadata2": "",
                                        "date": 0,
                                        "items": [],
                                        "email": "test@evertecinc.com",
                                        "status": "completed",
                                        "dailyTransactionID": 0]
        
        response[key] = value
        
        return NSDictionary(dictionary: response)
    }
}

