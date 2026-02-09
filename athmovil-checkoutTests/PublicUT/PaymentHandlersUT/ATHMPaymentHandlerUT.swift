//
//  ATHMPaymentHandlerUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentHandlerUT: XCTestCase {
    
    // MARK:- Positive
    
    func testWhenCompleteFromData_GivenStatusCompleted_ThenCompletedClosureIsCalled() {
        
        let response = getMockDate(key: "status", value: "completed")

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Opción 2: fallback con XCTFail
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: {
                XCTAssertEqual($0.status.status, .completed)
            },
            onExpired: { _ in
                XCTFail("Expired")
            },
            onCancelled: { _ in
                XCTFail("Cancelled")
            },
            onFailed: { _ in
                XCTFail("Failed")
            }
        ) { _ in
            XCTFail("Unexpected")
        }

        handler.completeFrom(data: data)
        

    }
    
    func testWhenCompleteFromData_GivenStatusExpired_ThenExpiredClosureIsCalled() {
        
        let response = getMockDate(key: "status", value: "expired")

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Fallback con XCTFail para tests (opción 2)
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: { _ in
                XCTFail("Completed")
            },
            onExpired: {
                XCTAssertEqual($0.status.status, .expired)
            },
            onCancelled: { _ in
                XCTFail("Cancelled")
            },
            onFailed: { _ in
                XCTFail("Failed")
            }
        ) { _ in
            XCTFail("Unexpected")
        }

        handler.completeFrom(data: data)

    }
    
    func testWhenCompleteFromData_GivenStatusCancelled_ThenCancelledClosureIsCalled() {
        
        let response = getMockDate(key: "status", value: "cancelled")

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Fallback con XCTFail
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: { _ in
                XCTFail("Completed")
            },
            onExpired: { _ in
                XCTFail("Expired")
            },
            onCancelled: {
                XCTAssertEqual($0.status.status, .cancelled)
            },
            onFailed: { _ in
                XCTFail("Failed")
            }
        ) { _ in
            XCTFail("Unexpected")
        }

        handler.completeFrom(data: data)

    }
    
    func testWhenCompleteFromData_GivenStatusFailed_ThenFailedClosureIsCalled() {
        
        let response = getMockDate(key: "status", value: "failed")

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Fallback con XCTFail para tests
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: { _ in
                XCTFail("Completed")
            },
            onExpired: { _ in
                XCTFail("Expired")
            },
            onCancelled: { _ in
                XCTFail("Cancelled")
            },
            onFailed: {
                XCTAssertEqual($0.status.status, .failed)
            }
        ) { _ in
            XCTFail("Unexpected")
        }

        handler.completeFrom(data: data)

    }
    
    func testWhenCompleteFromServer_GivenResponseCompleted_ThenCompletedClosureIsCalled() {
        
        let status = ATHMPaymentStatus(reference: "", dayliId: 0, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "Test", phoneNumber: "", email: "")
        let paymentResponse = ATHMPaymentResponse(payment: 20.0, status: status, customer: customer)
        
        let handler = ATHMPaymentHandler(onCompleted: {
            XCTAssertEqual($0.status.status, ATHMStatus.completed)
        }, onExpired: { (_) in
            XCTAssert(false)
        }, onCancelled: { (_) in
            XCTAssert(false)
        }, onFailed: { (_) in
            XCTAssert(false)
        }) { (_) in
            XCTAssert(false)
        }
        
        handler.completeFrom(serverPayment: paymentResponse)
    }
    
    func testWhenCompleteFromServer_GivenStatusExpired_ThenExpiredClosureIsCalled() {
        
        let status = ATHMPaymentStatus(reference: "", dayliId: 0, date: Date(), status: .expired)
        let customer = ATHMCustomer(name: "Test", phoneNumber: "", email: "")
        let paymentResponse = ATHMPaymentResponse(payment: 20.0, status: status, customer: customer)
                
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: {
            XCTAssertEqual($0.status.status, ATHMStatus.expired)
        }, onCancelled: { _ in
            XCTAssert(false)
        }, onFailed: { (_) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(serverPayment: paymentResponse)
    }
    
    func testWhenCompleteFromServer_GivenStatusCancelled_ThenCancelledClosureIsCalled() {
        
        let status = ATHMPaymentStatus(reference: "", dayliId: 0, date: Date(), status: .cancelled)
        let customer = ATHMCustomer(name: "Test", phoneNumber: "", email: "")
        let paymentResponse = ATHMPaymentResponse(payment: 20.0, status: status, customer: customer)
        
        let handler = ATHMPaymentHandler(onCompleted: { _ in
            XCTAssert(false)
        }, onExpired: { _ in
            XCTAssert(false)
        }, onCancelled: {
            XCTAssertEqual($0.status.status, ATHMStatus.cancelled)
        }, onFailed: { (_) in
            XCTAssert(false)
        }) { _ in
            XCTAssert(false)
        }
        
        handler.completeFrom(serverPayment: paymentResponse)
    }
    
    //MARK:- Negative
    
    func testWhenCompleteFromData_GivenEmptyStatus_ThenCancelledClosureAsDefault() {
        
        let response = getMockDate(key: "status", value: "")

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Fallback con XCTFail
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: { _ in
                XCTFail("Completed")
            },
            onExpired: { _ in
                XCTFail("Expired")
            },
            onCancelled: {
                XCTAssertEqual($0.status.status, .cancelled)
            },
            onFailed: { _ in
                XCTFail("Failed")
            }
        ) { _ in
            XCTFail("Unexpected")
        }

        handler.completeFrom(data: data)


    }
    
    //MARK:- Boundary
    
    func testWhenCompleteFromData_GivenUnexpectedStatus_ThenCancelledClosureAsDefault() {
        
        let response = getMockDate(key: "status", value: "hello")

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Fallback con XCTFail
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: { _ in
                XCTFail("Completed")
            },
            onExpired: { _ in
                XCTFail("Expired")
            },
            onCancelled: {
                XCTAssertEqual($0.status.status, .cancelled)
            },
            onFailed: { _ in
                XCTFail("Failed")
            }
        ) { _ in
            XCTFail("Unexpected")
        }

        handler.completeFrom(data: data)


    }
    
    func testWhenCompleteFromData_GivenNilStatus_ThenCancelledClosureAsDefault() {
        
        let response = getMockDate(key: "status", value: nil)

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Fallback con XCTFail
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: { _ in
                XCTFail("Completed")
            },
            onExpired: { _ in
                XCTFail("Expired")
            },
            onCancelled: {
                XCTAssertEqual($0.status.status, .cancelled)
            },
            onFailed: { _ in
                XCTFail("Failed")
            }
        ) { _ in
            XCTFail("Unexpected")
        }

        handler.completeFrom(data: data)


    }
    
    func testWhenCompleteFromData_GivenUnexpectedResponse_ThenExceptionClasureIsCalled() {
        
        let response: [String: Any] = [:]

        let jsonData = try? JSONSerialization.data(
            withJSONObject: response,
            options: .prettyPrinted
        )

        // Fallback con XCTFail
        let data = jsonData ?? {
            XCTFail("Error serializando JSON")
            return Data()
        }()

        let handler = ATHMPaymentHandler(
            onCompleted: { _ in
                XCTFail("Completed")
            },
            onExpired: { _ in
                XCTFail("Expired")
            },
            onCancelled: { (_: ATHMPaymentResponse) in
                XCTFail("Cancelled")
            },
            onFailed: { _ in
                XCTFail("Failed")
            }
        ) { _ in
            XCTAssert(true)
        }

        handler.completeFrom(data: data)

    }
    
    // Mark:- MockData
    
    func getMockDate(key: String, value: Any?) -> [String: Any?] {
        
        var response: [String: Any?] = ["name": "test",
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
        return response
    }


}

