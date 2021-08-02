//
//  RequestStatusUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class RequestStatusUT: XCTestCase {
    
    //MARK:- Positive

    func testWhenSendStatus_GivenADataAsCompletedResponse_ThenResponseSuccessWithTheTransactionAsCompleted() {
        
        let dataCompleteResponse = mockData()
        let requestStatus = APIClientMocK(response: dataCompleteResponse, networkError: nil)
        
        requestStatus.send(request: .status(paymentId: "Test",
                                            currentPayment: PaymentRequestMock(),
                                            completion: { result in
                                                    
                                                switch result {
                                                    case .success(let response):
                                                        XCTAssertEqual(response.status.status, .completed)
                                                        
                                                    default:
                                                        XCTAssert(false)
                                                }
                                                
                                            }))
    }
    
    func testWhenSendStatus_GivenSimulatedAPIClient_ThenResponseSuccessWithTheDummyTransactionAsCompleted() {
        
        let requestStatus = APIClientSimulated(paymentRequest: PaymentRequestMock())
        
        requestStatus.send(request: .status(paymentId: "Test",
                                            currentPayment: PaymentRequestMock(),
                                            completion: { result in
                                                
                                                switch result {
                                                    case .success(let response):
                                                        XCTAssertEqual(response.status.status, .completed)
                                                        
                                                    default:
                                                        XCTAssert(false)
                                                }
                                                
                                            }))
    }
    
    //MARK:- Negative
    
    func testWhenSendStatus_GivenADataAsUnexpectedResponseData_ThenResponseSuccessWithTheTransactionAsCancelled() {
        
        let unpextedResponseData = "Hello Word".data(using: .utf8)
        let requestStatus = APIClientMocK(response: unpextedResponseData, networkError: nil)
        
        requestStatus.send(request: .status(paymentId: "Test",
                                            currentPayment: PaymentRequestMock(),
                                            completion: { result in
                                                
                                                switch result {
                                                    case .success(let response):
                                                        XCTAssertEqual(response.status.status, .cancelled)
                                                        
                                                    default:
                                                        XCTAssert(false)
                                                }
                                                
                                            }))
    }
    
    //MARK:- Boundary
    
    func testWhenSendStatus_GivenAConnectionError_ThenResponseIsAnFailWithAnError() {
        
        let requestStatus = APIClientMocK(response: nil, networkError: .netWorkError)
        
        requestStatus.send(request: .status(paymentId: "Test",
                                            currentPayment: PaymentRequestMock(),
                                            completion: { result in
                                                
                                                switch result {
                                                    case .failure:
                                                        XCTAssert(true)
                                                        
                                                    default:
                                                        XCTAssert(false)
                                                }
                                                
                                            }))
    }
    
    func mockData() -> Data {
        
        let customer = ATHMCustomer(name: "Test", phoneNumber: "111 111 111", email: "test@test.com")
        let payment: ATHMPayment = 20.0
        let status = ATHMPaymentStatus(reference: "3124123123", dayliId: 1, date: Date(), status: .completed)
        
        let response = PaymentResponseCoder(payment: payment, customer: customer, status: status)
        let data = try! PaymentResponseCoder.encoder.encode(response)
        
        return data
    }
    
}
