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

class ATHMPaymentHandlerDictionaryUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenCompleteFromData_GivenStatusCompleted_ThenCompletedClosureIsCalled() {
        
        let responseMock = getMockDate(key: "status", value: "completed")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: {
            XCTAssertEqual($0, responseMock)
        }, onExpired: { (_) in
            XCTAssert(false)
        }, onCancelled: { (_) in
            XCTAssert(false)
        }) { (_) in
            XCTAssert(false)
        }
        
        handler.completeFrom(data: data)
    }
    
    func testWhenCompleteFromData_GivenStatusExpired_ThenExpiredClosureIsCalled() {
        
        let responseMock = getMockDate(key: "status", value: "expired")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: {
            XCTAssertEqual($0, responseMock)
        }, onCancelled: { _ in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(data: data)
    }
    
    func testWhenCompleteFromData_GivenStatusCancelled_ThenCancelledClosureIsCalled() {
        
        let responseMock = getMockDate(key: "status", value: "cancelled")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { _ in
            XCTAssert(false)
        }, onCancelled: {
            XCTAssertEqual($0, responseMock)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(data: data)
    }
    
    func testWhenCompleteFromServer_GivenResponseCompleted_ThenCompletedClosureIsCalled() {
        
        let status = ATHMPaymentStatus(reference: "123", dayliId: 1, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "Test", phoneNumber: "(222) 222-2222", email: "test@test.com")
        let paymentResponse = ATHMPaymentResponse(payment: 20.0, status: status, customer: customer)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: {
            XCTAssertEqual($0["status"], "completed")
        }, onExpired: { (_) in
            XCTAssert(false)
        }, onCancelled: { (_) in
            XCTAssert(false)
        }) { (_) in
            XCTAssert(false)
        }
        
        handler.completeFrom(serverPayment: paymentResponse)
    }
    
    func testWhenCompleteFromServer_GivenStatusExpired_ThenExpiredClosureIsCalled() {
        
        let status = ATHMPaymentStatus(reference: "42", dayliId: 2, date: Date(), status: .expired)
        let customer = ATHMCustomer(name: "Test", phoneNumber: "(222) 222-2222", email: "test@test.com")
        let paymentResponse = ATHMPaymentResponse(payment: 20.0, status: status, customer: customer)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: {
            XCTAssertEqual($0["status"], "expired")
        }, onCancelled: { _ in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(serverPayment: paymentResponse)
    }
    
    func testWhenCompleteFromServer_GivenStatusCancelled_ThenCancelledClosureIsCalled() {
        
        let status = ATHMPaymentStatus(reference: "2", dayliId: 4, date: Date(), status: .cancelled)
        let customer = ATHMCustomer(name: "Test", phoneNumber: "(222) 222-2222", email: "test@test.com")
        let paymentResponse = ATHMPaymentResponse(payment: 20.0, status: status, customer: customer)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: {
            XCTAssertEqual($0["status"], "cancelled")
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(serverPayment: paymentResponse)
    }
    
    //MARK:- Negative
    
    func testWhenCompleteFromData_GivenEmptyStatus_ThenCancelledClosureAsDefault() {
        
        let responseMock = getMockDate(key: "status", value: "")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { _ in
            XCTAssert(false)
        }, onCancelled: {
            XCTAssertEqual($0, responseMock)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(data: data)
    }
    
    func testWhenCompleteFromServer_GivenInvalidDataPayment_ThenOnExceptionClosureIsCalled() {
        
        let status = ATHMPaymentStatus(reference: "2", dayliId: 4, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "Test", phoneNumber: "(222) 222-2222", email: "test@test.com")
        let paymentResponse = ATHMPaymentResponse(payment: -20.0, status: status, customer: customer)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { _ in
            XCTAssert(false)
        }, onCancelled: { _ in
            XCTAssert(false)
        }) { error in
            XCTAssertEqual(error.source, .response)
        }
        
        handler.completeFrom(serverPayment: paymentResponse)
    }
    
    //MARK:- Boundary
    
    func testWhenCompleteFromData_GivenUnexpectedStatus_ThenCancelledClosureAsDefault() {
        
        let responseMock = getMockDate(key: "status", value: "hello")
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { _ in
            XCTAssert(false)
        }, onCancelled: {
            XCTAssertEqual($0, responseMock)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(data: data)
    }
        
    func testWhenCompleteFromData_GivenEmptyResponse_ThenExceptionClasureIsCalled() {
        
        let responseMock = NSMutableDictionary(dictionary: getMockDate(key: "status", value: "test"))
        responseMock.removeAllObjects()
        
        let data = try! JSONSerialization.data(withJSONObject: responseMock, options: .prettyPrinted)
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { _ in
            XCTAssert(false)
        }, onCancelled: { _ in
            XCTAssert(false)
        }) { _ in
            XCTAssert(true)
        }
        
        handler.completeFrom(data: data)
    }
    
    //Mark:- MockData
    
    func getMockDate(key: String, value: Any) -> NSDictionary {
        
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

