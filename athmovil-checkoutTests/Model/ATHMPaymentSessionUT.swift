//
//  ATHMPaymentSessionUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class ATHMPaymentSessionUT: XCTestCase{
    
    
    //MARK:- Positive
    
    func testWhenSetURL_GivenCompletedPaymentResponseURL_ThenSessionCallCompletedClosure(){

        let urlResponse = self.getResponseData(key: "status", value: "completed")
        let expecation = self.expectation(description: "PaymentCompleted")

        let handler = ATHMPaymentHandler(onCompleted: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.completed)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }

    func testWhenSetURL_GivenExpiredPaymentResponseURL_ThenSessionCallExpiredClosure(){

        let urlResponse = self.getResponseData(key: "status", value: "expired")
        let expecation = self.expectation(description: "PaymentExpired")

        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.expired)
            expecation.fulfill()
        }, onCancelled: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }
    
    func testWhenSetURL_GivenCancelledPaymentResponseURL_ThenSessionCallCancelledClosure(){

        let urlResponse = self.getResponseData(key: "status", value: "cancelled")
        let expecation = self.expectation(description: "PaymentCancelled")

        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }
    
    func testWhenSetURL_GivenSuccessPaymentResponseURL_ThenSessionCallCompletedClosure(){

        let urlResponse = getDeprecatedResponseData(key: "status", value: "Success")
        let expecation = self.expectation(description: "PaymentSuccess")

        let handler = ATHMPaymentHandler(onCompleted: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.completed)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }

    func testWhenSetURL_GivenCanceledPaymentResponseURL_ThenSessionCallCancelledClosure(){

        let urlResponse = getDeprecatedResponseData(key: "status", value: "Canceled")
        let expecation = self.expectation(description: "PaymentCanceled")

        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { (response: ATHMPaymentResponse) in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { response in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }
    
    func testWhenSetURL_GivenTimeOutPaymentResponseURL_ThenSessionCallTimeOutClosure(){

        let urlResponse = getDeprecatedResponseData(key: "status", value: "TimeOut")
        let expecation = self.expectation(description: "PaymentTimeOut")

        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { response in
            XCTAssertEqual(response.status.status, ATHMStatus.expired)
            expecation.fulfill()
        }, onCancelled: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }
    
    func testWhenSetURL_GivenPaymentResponseURL_ThenSessionHasZeroQueueHandlers(){

        let urlResponse = self.getResponseData(key: "", value: "")
        let expecation = self.expectation(description: "ZeroHanders")
        let session = ATHMPaymentSession()

        let handler = ATHMPaymentHandler(onCompleted: { _ in
            
            XCTAssertEqual(session.handlerQueue.count, 0)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
            
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssert(false)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        session.register(handler: handler)
        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }
    
    func testWhenRegisterHandler_GivenAnyHandler_ThenSessionHasOneHandler(){

        let session = ATHMPaymentSession()

        let handler = ATHMPaymentHandler(onCompleted: { _ in },
                                         onExpired: { _ in },
                                         onCancelled: { (response: ATHMPaymentResponse) in })
                                         { _ in }

        session.register(handler: handler)
        XCTAssertEqual(session.handlerQueue.count, 1)
    }
    
    
    //MARK:- Negative
    
    func testWhenSetURL_GivenEmptyStatusPaymentResponseURL_ThenSessionCallCancelledClosureAsDefault(){

        let urlResponse = self.getResponseData(key: "status", value: "")

        let expecation = self.expectation(description: "PaymentEmptyCancelledDefault")

        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }
    
    func testWhenSetURL_GivenEmptyStatusPaymentDeprecaredResponseURL_ThenSessionCallCancelledClosureAsDefault(){

        let urlResponse = self.getDeprecatedResponseData(key: "status", value: "")

        let expecation = self.expectation(description: "PaymentEmptyCancelledDefault")

        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }

        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse

        self.wait(for: [expecation], timeout: 2)

    }
    
    //MARK:- Boundary
    
    func testWhenSetURL_GivenUnexpectedStatusPaymentResponseURL_ThenSessionCallCancelledClosureAsDefault(){
        
        let urlResponse = self.getResponseData(key: "status", value: "hi")
        
        let expecation = self.expectation(description: "PaymentUnexpectedCancelledDefault")
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssertEqual(response.status.status, ATHMStatus.cancelled)
            expecation.fulfill()
        }) { _ in
            XCTAssert(false)
            expecation.fulfill()
        }
        
        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse
        
        self.wait(for: [expecation], timeout: 2)
        
    }
    
    func testWhenSetURL_GivenNilStatusPaymentResponseURL_ThenSessionCallOnExceptionClasure(){
        
        let urlResponse = self.getDeprecatedResponseData(key: "status", value: nil)
        
        let expecation = self.expectation(description: "PaymentUnexpectedCancelledDefault")
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }) { error in
            XCTAssert(true)
            expecation.fulfill()
        }
        
        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse
        
        self.wait(for: [expecation], timeout: 2)
        
    }
    
    func testWhenSetURL_GivenUnexpectedTotalInPaymentResponseURL_ThenDecodeThrowsAnException(){
        
        let urlResponse = self.getResponseData(key: "total", value: -12)
        
        let expecation = self.expectation(description: "DecodeException")
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssert(false)
            expecation.fulfill()
        }) { _ in
            XCTAssert(true)
            expecation.fulfill()
        }
        
        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse
        
        self.wait(for: [expecation], timeout: 2)
        
    }
    
    func testWhenSetUrlAsResponse_GivenUnexpectedResponse_ThenSessionCallOnExceptionBlock(){
        
        let response = "{}".toJSON
        let urlResponse = URL(string: "urlATHMovil://?athm_payment_data=\(response!)")!
        
        let expecation = self.expectation(description: "PaymentUnexpectedCancelledDefault")
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onExpired: { _ in
            XCTAssert(false)
            expecation.fulfill()
        }, onCancelled: { (response: ATHMPaymentResponse) in
            XCTAssert(false)
            expecation.fulfill()
        }) { error in
            XCTAssert(true)
            expecation.fulfill()
        }
        
        let session = ATHMPaymentSession()
        session.register(handler: handler)

        session.url = urlResponse
        
        self.wait(for: [expecation], timeout: 3)
    }
    
    func testWhenRegisterHandler_GivenTwoAnyHandler_ThenSessionHasOneHandler(){

        let session = ATHMPaymentSession()

        let firstHandler = ATHMPaymentHandler(onCompleted: { _ in },
                                         onExpired: { _ in },
                                         onCancelled: { (response: ATHMPaymentResponse) in })
                                         { _ in }
        
        let secondHandler = ATHMPaymentHandler(onCompleted: { _ in },
                                         onExpired: { _ in },
                                         onCancelled: { (response: ATHMPaymentResponse) in })
                                         { _ in }

        session.register(handler: firstHandler)
        session.register(handler: secondHandler)
        
        XCTAssertEqual(session.handlerQueue.count, 1)
    }
    
    //MARK:- MockData

    func getResponseData(key: String, value: Any?) -> URL{
        
        var fullResponse: [String: Any] = ["name": "test",
                                           "phoneNumber": "7871234567",
                                           "metadata1": "test metadata1",
                                           "tax": 1,
                                           "version": "3.0",
                                           "total": 2.0,
                                           "referenceNumber": "123456",
                                           "subtotal": 1,
                                           "metadata2": "test metadata2",
                                           "date": 0,
                                           "items": [["name": "test", "price": 1, "quantity": 1, "desc": "test"]],
                                           "email": "test@evertecinc.com",
                                           "status": "completed",
                                           "dailyTransactionID": 1
        ]
        
        fullResponse[key] = value
        
        let valueResponse = fullResponse.toJSONString!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let url = URL(string: "urlATHMovil://?athm_payment_data=\(valueResponse!)")!
                
        return url
        
    }
    
    func getDeprecatedResponseData(key: String, value: Any?) -> URL{
        
        var fullResponse: [String: Any] = ["metadata1": "test metadata1",
                                           "tax": 1,
                                           "total": 2.0,
                                           "transactionReference": "123456",
                                           "subtotal": 1,
                                           "metadata2": "test metadata2",
                                           "items": [["name": "test", "price": 1, "quantity": 1, "desc": "test"]],
                                           "status": "Success",
                                           "dailyTransactionId": "#01"
        ]
        
        fullResponse[key] = value
        
        let valueResponse = fullResponse.toJSONString!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let url = URL(string: "urlATHMovil://?athm_payment_data=\(valueResponse!)")!
                
        return url

    }
    
}

