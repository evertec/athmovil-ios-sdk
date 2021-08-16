//
//  ATHMPaymentRequestUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentRequestUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenSendPayment_GivenExpectedRequestPayment_ThenCanOpenTheTargetApplication() {
        let requestPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(token: "test"),
                                                scheme: ATHMURLScheme(urlScheme: "test"),
                                                payment: ATHMPayment(total: 1))
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in
            XCTAssertTrue(true)
        }
        
        requestPayment.sendPayment(handler, urlopener: urlOpener)
    }
    
    func testWhenSendPayment_GivenExpectedRequestPaymentDictionary_ThenCanOpenTheTargetApplication() {
        let requestPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(dictionary: NSDictionary(dictionary: ["publicToken": "test"])),
                                                scheme: ATHMURLScheme(dictionary: NSDictionary(dictionary: ["scheme": "test"])),
                                                payment: ATHMPayment(dictionary: NSDictionary(dictionary: ["total": 1])))
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in
            XCTAssertTrue(true)
        }
        
        requestPayment.sendPayment(handler, urlopener: urlOpener)
    }
    

    //MARK:- Negative
    
    func testWhenSendPayment_GivenPaymentWithNegativeTotal_ThenCancelRequestTheRequestAndCallOnException() {
        let requestPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(token: "test"),
                                               scheme: ATHMURLScheme(urlScheme: "test"),
                                               payment: ATHMPayment(total: -1))
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssert(false)
        }) { error in
            XCTAssert(true)
        }
    
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in }
        
        requestPayment.sendPayment(handler, urlopener: urlOpener)
    }
    
    func testWhenSendPayment_GivenPaymentRequestWithNegativeTotal_ThenCancelRequestTheRequestAndCallOnException() {
        let negativeTotalDic = NSDictionary(dictionary: ["total" : -20.0])
        let requestPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(dictionary: NSDictionary(dictionary: ["token": "test"])),
                                                scheme: ATHMURLScheme(dictionary: NSDictionary(dictionary: ["urlScheme": "test"])),
                                                payment: ATHMPayment(dictionary: negativeTotalDic))
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { error in
            XCTAssert(true)
        }
        
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in }
        
        requestPayment.sendPayment(handler, urlopener: urlOpener)
    }
    
    
    
    //MARK:- Boundary
    
    
    func testWhenSendPayment_GivenPaymentRequestAsEmptyDictionary_ThenCancelRequestTheRequestAndCallOnException() {
        let emptyDictionary = NSDictionary(dictionary: [AnyHashable : Any]())
        let requestPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(dictionary: emptyDictionary),
                                                scheme: ATHMURLScheme(dictionary: emptyDictionary),
                                                payment: ATHMPayment(dictionary: emptyDictionary))
        
        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { error in
            XCTAssert(true)
        }
        
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in }
        
        requestPayment.sendPayment(handler, urlopener: urlOpener)
    }
    
}

