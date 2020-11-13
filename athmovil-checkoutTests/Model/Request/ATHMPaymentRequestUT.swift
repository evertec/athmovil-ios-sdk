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

class ATHMPaymentRequestUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenSendPayment_GivenExpectedPayment_ThenCanOpenTheTargetApplication(){
        let requetPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(token: "test"),
                                               appClient: ATHMClientApp(urlScheme: "test"),
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
        
        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in
            XCTAssertTrue(true)
        }
        
        requetPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    func testWhenSendPayment_GivenExpectedPayment_ThenThereIsARequestInQueue(){
        let requetPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(token: "test"),
                                               appClient: ATHMClientApp(urlScheme: "test"),
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
        
        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in
            XCTAssertEqual(session.handlerQueue.count, 1)
        }
        
        requetPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    //MARK:- Negative
    
    func testWhenSendPayment_GivenPaymentWithNegativeTotal_ThenCancelRequestTheRequestAndCallOnException(){
        let requetPayment = ATHMPaymentRequest(account: ATHMBusinessAccount(token: "test"),
                                               appClient: ATHMClientApp(urlScheme: "test"),
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
        

        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in }
        
        requetPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    //MARK:- Boundary
    
    
}

