//
//  RequestPaymentUT.swift
//  athmovil-checkoutTests
//
//  Created by Ismael Paredes on 12/02/23.
//  Copyright © 2023 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class RequestPaymentUT: XCTestCase {
    
    //MARK:- Positive

    func testWhenSendPayment_GivenADataAsCompletedResponse_ThenResponseSuccessWithTheTransactionAsCompleted() {
        
        let dataCompleteResponse = mockData()
        let request = APIClientMock(response: dataCompleteResponse)
        
        request.send(request: .payment(currentPayment: PaymentSecureRequestMock(),
            completion: { result in
                    
                switch result {
                    case .success(let response):
                        XCTAssertEqual(response.status, "success")
                        
                    default:
                        XCTAssert(false)
                }
                
            }))
    }
    
    func testWhenSendPayment_ThenResponseEcommerceIDWithTheTransactionAsCompleted() {
        
        let request = APIClientSimulated(paymentRequest: PaymentRequestMock())
        
        request.send(request: .payment(currentPayment: PaymentSecureRequestMock(),
        completion: { result in
            
            switch result {
                case .success(let response):
                XCTAssertEqual(response.data.ecommerceID, "18a2d3fa-3dc1-11ed-a1c1-e19d31c39706")
                    
                default:
                    XCTAssert(false)
            }
            
        }))
    }
    
    //MARK:- Negative
    
    func testWhenSendPayment_GivenAConnectionError_ThenResponseIsAnFailWithAnError() {
        
        let request = APIClientMock(response: nil)
        
        request.send(request: .payment(currentPayment: PaymentSecureRequestMock(),
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
        let status = "success"
        let dataclass = DataClass(ecommerceID: "18a2d3fa-3dc1-11ed-a1c1-e19d31c39706", authToken: "token")
        let response = PaymentSecureResponseCodable(status: status, data: dataclass)
        let data = try! PaymentSecureResponseCodable.encoder.encode(response)
        return data
    }
    
}
