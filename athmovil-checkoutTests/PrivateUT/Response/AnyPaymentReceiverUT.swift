//
//  AnyPaymentReceiverUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class AnyPaymentReceiverUT: XCTestCase {
    
    //MARK:- Positive
    
    func testWhenCompleteTransactionWithDeepLink_GivenAExpectedResponse_ThenCallCompletedCallBack() {
        
        let mockData = getResponseData(key: "status", value: "completed")
        let paymentRequest = ATHMPaymentRequest(account: "Test", scheme: "https://", payment: 20.0)
        
        let paymentHandlerResponse = PaymentHandleableMock(onCompleted: { result in
            XCTAssertEqual(result.status.status, .completed)
        })
        
        let responser = AnyPaymentReceiver(paymentContent: paymentRequest,
                                           handler: paymentHandlerResponse,
                                           session: .shared,
                                           apiClient: APIClientMock())
        
        responser.completed(by: .deepLink(mockData))
        
    }
    
    func testWhenCompleteTransactionFromBecomeActive_GivenADummyPayment_ThenCallClosureCompletedWithDummyData() {
        
        let expectationSerive = self.expectation(description: "GettingFromService")
        let paymentRequest = ATHMPaymentRequest(account: "Test", scheme: "https://", payment: 20.0)
        
        let paymentHandlerResponse = PaymentHandleableMock(onCompleted: { result in
            XCTAssertEqual(result.status.status, .completed)
            expectationSerive.fulfill()
        })
        
        let clientDummy = APIClientSimulated(paymentRequest: PaymentSimulated(paymentRequest: paymentRequest))
        let responser = AnyPaymentReceiver(paymentContent: PaymentSimulated(paymentRequest: paymentRequest),
                                           handler: paymentHandlerResponse,
                                           session: .shared,
                                           apiClient: clientDummy)
        
        responser.completed(by: .becomeActive)
        wait(for: [expectationSerive], timeout: 4)
        
    }
        
    func getResponseData(key: String, value: Any?) -> Data {
        
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
        
        let dataResponse = try! JSONSerialization.data(withJSONObject: fullResponse, options: .prettyPrinted)
                
        return dataResponse
    }
}
