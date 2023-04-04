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


class ATHMPaymentSessionUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenSetURLResponse_GivenExpectedURLSchemeResponse_ThenSessionProccessTheURLResponse() {
        
        let urlResponse = getResponseData(key: "status", value: "completed")
        let handler = PaymentHandleableMock(onCompletedData: { data in
            XCTAssertNotNil(data)
        })
        
        let session = ATHMPaymentSession.shared
        session.currentPayment = AnyPaymentReceiver(paymentContent: PaymentRequestMock(),
                                                    handler: handler,
                                                    session: session,
                                                    apiClient: APIClientMock())
        
        session.url = urlResponse
    }
    
    func testWhenSetURLResponse_GivenExpectedURLSchemeResponseDeprecated_ThenSessionProccessTheURLResponse() {
        
        let urlResponse = getDeprecatedResponseData(key: "status", value: "completed")
        
        let handler = PaymentHandleableMock(onCompletedData: { data in
            XCTAssertNotNil(data)
        })
        
        let session = ATHMPaymentSession.shared
        session.currentPayment = AnyPaymentReceiver(paymentContent: PaymentRequestMock(),
                                                    handler: handler,
                                                    session: session,
                                                    apiClient: APIClientMock())
        
        session.url = urlResponse
    }
    
    func testWhenNotifyBecomeActive_GivenADummyCurrentPayment_ThenSessionProccessGetResponseFromWebService() {
        
        let expectation = self.expectation(description: "TransactionDummy")
        let handler = PaymentHandleableMock(onCompleted:{ response in
            XCTAssertNotNil(response)
            expectation.fulfill()
        })
            
        let session = ATHMPaymentSession.shared
        let payment = ATHMPaymentRequest(account: "dummy", scheme: "attt://", payment: 20.0)
        let clientDummy = APIClientSimulated(paymentRequest: PaymentSimulated(paymentRequest: payment))
        session.currentPayment = AnyPaymentReceiver(paymentContent: PaymentSimulated(paymentRequest: payment),
                                                    handler: handler,
                                                    session: session,
                                                    apiClient: clientDummy)
        
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        wait(for: [expectation], timeout: 4)
    }
    
    
    //MARK:- Negative
    
    func testWhenSetURL_GivenURLSchemeWithEmptyData_ThenTryToProccessTheData() {
        
        let response = "{}".toJSON
        let urlResponse = URL(string: "urlATHMovil://?athm_payment_data=\(response!)")!
        
        let handler = PaymentHandleableMock(onCompletedData: { data in
            XCTAssertFalse(data.isEmpty)
        })
        
        let session = ATHMPaymentSession.shared
        session.currentPayment = AnyPaymentReceiver(paymentContent: PaymentRequestMock(),
                                                    handler: handler,
                                                    session: session,
                                                    apiClient: APIClientMock())
        
        session.url = urlResponse
    }
    
    //MARK:- Boundary
    
    func testWhenSetURLAndOneRequest_GivenUnExpectedURLScheme_ThenSessionKeepsTheLastRequest() {
        
        let session = ATHMPaymentSession.shared
        let urlResponse = URL(string: "urlTest://?unexpected_param")!
        let handler = PaymentHandleableMock(onCompleted: { _ in
            XCTAssert(false)
        })
        
        session.currentPayment = AnyPaymentReceiver(paymentContent: PaymentRequestMock(),
                                                    handler: handler,
                                                    session: session,
                                                    apiClient: APIClientMock())
        session.url = urlResponse
    }
        
    func testWhenSessionIsCreated_GivenTwoDifferentThreads_ThenSessionIsTheSameObject() {
        
        let expectation = self.expectation(description: "SessionThreadSafe")
        let queuMain = OperationQueue()
        queuMain.maxConcurrentOperationCount = 2
        
        var firstInstance: ATHMPaymentSession?
        var secondInstance: ATHMPaymentSession?
        
        let fistOperation = BlockOperation { firstInstance = ATHMPaymentSession.shared }
        let secondOperation = BlockOperation { secondInstance = ATHMPaymentSession.shared }
        
        let operationAssert = BlockOperation {
            XCTAssertEqual(firstInstance, secondInstance)
            expectation.fulfill()
        }
        
        operationAssert.addDependency(fistOperation)
        operationAssert.addDependency(secondOperation)
        
        queuMain.addOperations([fistOperation, secondOperation, operationAssert], waitUntilFinished: false)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testWhenNotifyBecomeActiveTwice_GivenADummyCurrentPayment_ThenProccessPaymentOnlyOneTime() {
        
        let expectation = self.expectation(description: "TransactionDummy")
        let handler = PaymentHandleableMock(onCompleted:{ response in
            XCTAssertNotNil(response)
            expectation.fulfill()
        })
        
        let session = ATHMPaymentSession.shared
        let payment = ATHMPaymentRequest(account: "dummy", scheme: "attt://", payment: 20.0)
        let clientDummy = APIClientSimulated(paymentRequest: PaymentSimulated(paymentRequest: payment))
        session.currentPayment = AnyPaymentReceiver(paymentContent: PaymentSimulated(paymentRequest: payment),
                                                    handler: handler,
                                                    session: session,
                                                    apiClient: clientDummy)
        
        expectation.expectedFulfillmentCount = 1
        
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        wait(for: [expectation], timeout: 4)
    }
    
    func testWhenNotifyBecomeActiveAndSetURLAtSameTime_GivenADummyCurrentPayment_ThenProccessByURL() {
        
        let urlResponse = getResponseData(key: "status", value: "completed")
        let expectation = self.expectation(description: "TransactionDummy")
        let handler = PaymentHandleableMock(onCompletedData: { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        })
        
        let session = ATHMPaymentSession.shared
        let payment = ATHMPaymentRequest(account: "dummy", scheme: "attt://", payment: 20.0)
        session.currentPayment = AnyPaymentReceiver(paymentContent: PaymentSimulated(paymentRequest: payment),
                                                    handler: handler,
                                                    session: session,
                                                    apiClient: APIClientMock())
        
        expectation.expectedFulfillmentCount = 1
        
        session.url = urlResponse
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        wait(for: [expectation], timeout: 4)
    }
    
    
    //MARK:- MockData
    
    func getResponseData(key: String, value: Any?) -> URL {
        
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
    
    func getDeprecatedResponseData(key: String, value: Any?) -> URL {
        
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

