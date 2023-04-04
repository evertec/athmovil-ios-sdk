//
//  AnyPaymentSenderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/4/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class AnyPaymentSenderUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenSendPayment_GivenTargetURLDummy_ThenOpenASiteWithAnValidURL(){
        
        let paymentMock = PaymentRequestMock()
        let handlerMock = PaymentHandleableMock(onCompleted: { _ in })
        
        let urlOpener = URLOpenerStub { (url, options) in
            XCTAssertNotNil(url)
        }
        
        let paymentSender = AnyPaymentSender(paymentRequest: paymentMock,
                                             paymentHandler: handlerMock,
                                             paymentOpener: urlOpener)
        
        paymentSender.sendPayment(target: TargetURLScheme.athMovil(.production), session: .shared)
    }
    
    //MARK:- Negative
    
    func testWhenSendPayment_GivenTargetWithCustomNilURLRepresentation_ThenCallOnExceptionWithAPaymentError(){
        
        let urlOpener = URLOpenerStub()
        let paymentMock = PaymentRequestMock()
        let handlerMock = PaymentHandleableMock(onException: { paymentError in
            XCTAssertEqual(paymentError.source, .request)
        })
        
        let paymentSender = AnyPaymentSender(paymentRequest: paymentMock,
                                             paymentHandler: handlerMock,
                                             paymentOpener: urlOpener)
                
        paymentSender.sendPayment(target: TargetURLScheme.athMovil(.production), session: .shared)
    }
    
    //MARK:- Boundary
    
    
    func testWhenSendPayment_GivenTargetWithCustomNilURLAndNilError_ThenCallOnExceptionWithAPaymentError(){
        
        let urlOpener = URLOpenerStub()
        let paymentMock = PaymentRequestMock()
        let handlerMock = PaymentHandleableMock { paymentError in
            XCTAssertEqual(paymentError.source, .request)
        }
        let paymentSender = AnyPaymentSender(paymentRequest: paymentMock,
                                             paymentHandler: handlerMock,
                                             paymentOpener: urlOpener)
        
        paymentSender.sendPayment(target: TargetURLScheme.athMovil(.production), session: .shared)
    }
    
    
    // MARK:- DataMock
    
    var anyPaymentCoder: AnyPaymentCoderMock {
        AnyPaymentCoderMock(businessAccount: BusinessAccountCoderMock(businessTest: "TestBusiness"),
                            scheme: URLSchemeCoderMock(clientTest: "ClientTest"),
                            payment: PaymentCoderMock(paymentTest: "PaymentTest"))
    }
}
