//
//  AnyPaymentRequestCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class AnyPaymentRequestCoderUT: XCTestCase {
    
    
    //MARK:- Positive
        
    func testWhenEncodeAnyPaymentRequest_GivenPaymentInfoWithTimeoutValue_ThenPaymentRequestEncodeTimeout() {
        
        let request = getMockData(timeOut: 120, business: "test", scheme: "test", traceId: "XXX", payment: 20.0)
        
        do {
            try XCTAssertEncode(encode: request) {
                XCTAssertEqual($0["expiresIn"] as? Double, 120)
            }
        } catch {
            XCTFail("Error encoded request: \(error)")
        }
    }
    
    func testWhenEncodeAnyPaymentRequest_GivenPaymentInfoWithCurrentVersionValue_ThenPaymentRequestEncodeVersion() {
        
        let request = getMockData(timeOut: 120, business: "test", scheme: "test", traceId: "CCCC", payment: 1.0)
        
        do {
            try XCTAssertEncode(encode: request) {
                XCTAssertEqual($0["version"] as? String, "3.0")
            }
        } catch {
            XCTFail("Error encoded request: \(error)")
        }
    }
    
    func testWhenEncodeAnyPaymentRequest_GivenPaymentInfoWithTraceId_ThenPaymentRequestEncodeTraceId() {
        
        let request = getMockData(timeOut: 120, business: "test", scheme: "test", traceId: "ADSASFRER4324324324", payment: 1.0)
        
        do {
            try XCTAssertEncode(encode: request) {
                XCTAssertEqual($0["traceId"] as? String, "ADSASFRER4324324324")
            }
        } catch {
            XCTFail("Error encoded request: \(error)")
        }
    }
    
    func testWhenGetCurrentVersion_GivenAnyPaymentRequest_ThenTheVersionIsThree() {
        
        let request = getMockData(timeOut: 120, business: "test", scheme: "test", traceId: "TTT", payment: 1.0)
        
        XCTAssertEqual(request.paymentRequest.version, ATHMVersion.three)
    }
    
    
    //MARK:- Negative
    
    func testWhenEncodePaymentRequest_GivenInvalidTimeOut_ThenThrowsException() {
        
        let request = getMockData(timeOut: 20, business: "test", scheme: "test", traceId: "XXX", payment: 1.0)
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
            
        })) { error in
            let paymentError = error as? ATHMPaymentError
            XCTAssertEqual(paymentError?.failureReason, "Timeout data type value is invalid")
            XCTAssertEqual(paymentError?.source, .request)
        }
        
    }
    
    //MARK:- Boundary
    
    func testWhenEncodeAnyRequest_GivenEncodeException_ThenThrowsAnATHMMovilException() {
                
        let paymentMock = PaymentRequestMock()
        
        let request = AnyPaymentRequestCoder(paymentRequest: paymentMock, traceId: "")
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: request, assert: { _ in
            XCTAssert(false)
        })) { error in
            XCTAssert(error is ATHMPaymentError)
        }
    }
    
    
    
    //MARK:- MockData
    
    func getMockData(timeOut: Double,
                     business: String,
                     scheme: String,
                     traceId: String,
                     payment: NSNumber) -> AnyPaymentRequestCoder<PaymentRequestMock> {
        
        let paymentMock = PaymentRequestMock(businessAccount: ATHMBusinessAccount(token: business),
                                             scheme: ATHMURLScheme(urlScheme: scheme),
                                             payment: ATHMPayment(total: payment),
                                             timeout: timeOut)
        
        return AnyPaymentRequestCoder(paymentRequest: paymentMock, traceId: traceId)
    }

}
