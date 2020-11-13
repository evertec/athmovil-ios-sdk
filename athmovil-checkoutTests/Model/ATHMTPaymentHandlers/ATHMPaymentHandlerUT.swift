//
//  ATHMPaymentHandlerUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentHandlerUT: XCTestCase{
    
    
    //MARK:- Positive
    
    func testWhenConfirmTransaction_GivenStatusCompleted_ThenCompletedClosureIsCalled(){
        
        let response = getMockDate(key: "status", value: "completed")
        
        let data = try! JSONSerialization.data(withJSONObject: response,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let handler = ATHMPaymentHandler(onCompleted: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.completed)
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
        
        let response = getMockDate(key: "status", value: "expired")
        
        let data = try! JSONSerialization.data(withJSONObject: response,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.expired)
        }, onCancelled: { _ in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    func testWhenConfirmTransaction_GivenStatusCancelled_ThenCancelledClosureIsCalled(){
        
        let response = getMockDate(key: "status", value: "cancelled")
        
        let data = try! JSONSerialization.data(withJSONObject: response,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    //MARK:- Negative
    
    func testWhenConfirmTransaction_GivenEmptyStatus_ThenCancelledClosureAsDefault(){
        
        let response = getMockDate(key: "status", value: "")
        
        let data = try! JSONSerialization.data(withJSONObject: response,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    //MARK:- Boundary
    
    func testWhenConfirmTransaction_GivenUnexpectedStatus_ThenCancelledClosureAsDefault(){
        
        let response = getMockDate(key: "status", value: "hello")
        
        let data = try! JSONSerialization.data(withJSONObject: response,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    func testWhenConfirmTransaction_GivenNilStatus_ThenCancelledClosureAsDefault(){
        
        let response = getMockDate(key: "status", value: nil)
        
        let data = try! JSONSerialization.data(withJSONObject: response,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.confirm(from: data)
    }
    
    func testWhenConfirmTransaction_GivenUnexpectedResponse_ThenExceptionClasureIsCalled(){
        
        var response = getMockDate(key: "status", value: nil)
        response.removeAll()
        
        let data = try! JSONSerialization.data(withJSONObject: response,
                                               options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(true)
        }
        
        handler.confirm(from: data)
    }
    
    //Mark:- MockData
    
    func getMockDate(key: String, value: Any?) -> [String: Any?]{
        
        var response: [String: Any?] = ["name": "test",
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
        return response
    }


}

