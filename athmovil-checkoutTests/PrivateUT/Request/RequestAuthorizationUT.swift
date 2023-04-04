//
//  RequestAuthorizationUT.swift
//  athmovil-checkoutTests
//
//  Created by Ismael Paredes on 14/02/23.
//  Copyright © 2023 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class RequestAuthorizationUT: XCTestCase {
    
    //MARK:- Positive

    func testWhenSendAuthorization_GivenADataAsCompletedResponse_ThenResponseSuccessWithTheTransactionAsCompleted() {
        
        let dataCompleteResponse = mockData()
        let request = APIClientMock(response: dataCompleteResponse)
        
        request.send(request: .authorization(
        completion: { result in
                switch result {
                    case .success(let response):
                        XCTAssertEqual(response.status, ATHMAuthorizationResponse.TypeStatus.success)
                default:
                        XCTAssert(false)
                }
            }
        ))
    }
    
    func testWhenSendAuthorization_ThenResponseEcommerceIDWithTheTransactionAsCompleted() {
        
        let request = APIClientSimulated(paymentRequest: PaymentRequestMock())
        
        request.send(request: .authorization(
        completion: { result in
            
            switch result {
                case .success(let response):
                XCTAssertEqual(response.status, ATHMAuthorizationResponse.TypeStatus.success)
                    
                default:
                    XCTAssert(false)
            }
            
        }))
    }
    
    //MARK:- Negative
    
    func testWhenSendAuthorization_GivenADataAsUnexpectedResponseData_ThenResponseSuccessWithTheTransactionAsCancelled() {
        
        let unpextedResponseData = "Hello Word".data(using: .utf8)
        let request = APIClientMock(response: unpextedResponseData)
        
        request.send(request: .authorization(
        completion: { result in
            
            switch result {
                case .failure(let error):
                XCTAssertEqual(error.message, "Sorry for the inconvenience. Please try again later.")
                default:
                    XCTAssert(false)
            }
            
        }))
    }
    
    //MARK:- Boundary
    
    func testWhenSendAuthorization_GivenAConnectionError_ThenResponseIsAnFailWithAnError() {
        
        let request = APIClientMock(response: nil)
        
        request.send(request: .authorization(
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
        let status = ATHMAuthorizationResponse.TypeStatus.success
        let dataclass = PaymentData(dailyTransactionId: "0013", referenceNumber: "215070682-8a36d42f859d623b0185a1a80b08009d", fee: 0.05999999865889549, netAmount: 0.95)
        let response = AuthorizationResponseCodable(status: status, data: dataclass, message: "")
        let data = try! AuthorizationResponseCodable.encoder.encode(response)
        return data
    }
    
}
