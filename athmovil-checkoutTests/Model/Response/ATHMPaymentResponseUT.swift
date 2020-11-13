//
//  ATHMPaymentResponseUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class ATHMPaymentResponseUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenInitPaymentResponse_GivenPayment_ThenResponseHasPayment(){
        
        let payment = ATHMPayment(total: 1)
        let status = ATHMPaymentStatus(reference: "test", dayliId: 1, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "test", phoneNumber: "123456789", email: "test@gmail.com")
        
        let paymentResponse = ATHMPaymentResponse(payment: payment, status: status, customer: customer)
        
        XCTAssertNotNil(paymentResponse.payment)
        
    }
    
    func testWhenInitPaymentResponse_GivenStatus_ThenResponseHasStatus(){
        
        let payment = ATHMPayment(total: 1)
        let status = ATHMPaymentStatus(reference: "test", dayliId: 1, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "test", phoneNumber: "123456789", email: "test@gmail.com")
        
        let paymentResponse = ATHMPaymentResponse(payment: payment, status: status, customer: customer)
        
        XCTAssertNotNil(paymentResponse.status)
        
    }
    
    func testWhenInitPaymentResponse_GivenCustomer_ThenResponseHasCustomer(){
        
        let payment = ATHMPayment(total: 1)
        let status = ATHMPaymentStatus(reference: "test", dayliId: 1, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "test", phoneNumber: "123456789", email: "test@gmail.com")
        
        let paymentResponse = ATHMPaymentResponse(payment: payment, status: status, customer: customer)
        
        XCTAssertNotNil(paymentResponse.customer)
    }
    
    func testWhenGetDescription_GivenPayment_ThenPrintPaymentResponse(){
        let payment = ATHMPayment(total: 1)
        let status = ATHMPaymentStatus(reference: "test", dayliId: 1, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "test", phoneNumber: "123456789", email: "test@gmail.com")
        
        let paymentResponse = ATHMPaymentResponse(payment: payment, status: status, customer: customer)
        
        XCTAssertFalse(paymentResponse.description.isEmpty)
        
    }
    
    //MARK:- Negative
    
    func testWhenGetDescription_GivenPaymentWithAllPropertiesEmpty_ThenPrintPaymentResponse(){
        let payment = ATHMPayment(total: 0)
        let status = ATHMPaymentStatus(reference: "", dayliId: 0, date: Date(), status: .completed)
        let customer = ATHMCustomer(name: "", phoneNumber: "", email: "")
        
        let paymentResponse = ATHMPaymentResponse(payment: payment, status: status, customer: customer)
        
        XCTAssertFalse(paymentResponse.description.isEmpty)
        
    }
    
    //MARK:- Boundary
    
}

