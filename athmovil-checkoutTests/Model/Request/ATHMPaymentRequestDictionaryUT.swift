//
//  ATHMPaymentRequestDictionaryUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 9/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentRequestDictionaryUT: XCTestCase{
    
    //MARK:- Positive
    

    func testWhenSendPayment_GivenExpectedRequestDictionary_ThenCanOpenTheTargetApplication(){
        
        let requestPayment = ATHMPaymentDictionaryRequest(dictionary: self.getRequestMock())

        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }

        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in
            XCTAssertTrue(true)
        }
        
        requestPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    func testWhenSendPayment_GivenExpectedDictionaryPayment_ThenThereIsARequestInQueue(){
        let requestPayment = ATHMPaymentDictionaryRequest(dictionary: self.getRequestMock())

        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }

        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in
            XCTAssertEqual(session.handlerQueue.count, 1)
        }

        requestPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    //MARK:- Negative
    
    func testWhenSendPayment_GivenEmptyDictionary_ThenCancelRequestTheRequestAndCallOnException(){
        
        let dictionary = NSDictionary()
        
        let requestPayment = ATHMPaymentDictionaryRequest(dictionary: dictionary)

        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(true)
        }

        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in }
        
        requestPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    
    //MARK:- Boundary
    
    func testWhenSendPayment_GivenDictionaryPaymentWithNegativeTotal_ThenCancelRequestTheRequestAndCallOnException(){
        
        let dictionary = NSMutableDictionary(dictionary: self.getRequestMock())
        dictionary["total"] = -102
        
        let requestPayment = ATHMPaymentDictionaryRequest(dictionary: dictionary)

        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(true)
        }

        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in }
        
        requestPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    func testWhenSendPayment_GivenMissingItemsKey_ThenCanOpenTheTargetApplication(){
        
        let dictionary = NSMutableDictionary(dictionary: self.getRequestMock())
        dictionary.removeObject(forKey: "items")
        
        let requestPayment = ATHMPaymentDictionaryRequest(dictionary: dictionary)

        let handler = ATHMPaymentHandlerDictionary(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { (response) in
            XCTAssert(false)
        }, onCancelled: { (response: NSDictionary) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }

        let session = ATHMPaymentSession()
        let urlOpener = URLOpenerStub { (url, _: [UIApplication.OpenExternalURLOptionsKey : Any]) in
            XCTAssertTrue(true)
        }
        
        requestPayment.sendPayment(handler: handler, urlAdaptable: urlOpener, session: session)
    }
    
    
    //MARK:- Mock
    
    func getRequestMock() -> NSDictionary{
        let request = NSDictionary(dictionary: ["scheme": "test",
                                                "publicToken": "12345",
                                                "total": 20.0,
                                                "subtotal": 1,
                                                "tax": "2",
                                                "metadata1": "This is metadata 1",
                                                "metadata2": "This is metadata 2",
                                                "items":[["name": "ItemTest",
                                                          "price": 2.0,
                                                          "quantity": 1,
                                                          "desc": "Description",
                                                          "metadata": "Metadata"]]])
                
        return request
        
    }
}

