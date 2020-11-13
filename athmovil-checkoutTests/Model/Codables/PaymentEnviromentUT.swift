//
//  PaymentEnviromentUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

class PaymentEnviromentUT: XCTestCase{
    
    typealias RequestType = AnyPaymentRequestCoder<BusinessAccountCoder, ClientAppCoder, PaymentCoder>
    
    //MARK:- Positive
    
    func testWhenGetURlRepresentation_GivenPaymentRequest_ThenGetAValidURLOfRequest(){
        
        let payment = getMockData(business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMClientApp(urlScheme: "test"),
                                  payment: ATHMPayment(total: 1),
                                  timeout: 140)
        
        let enviroment = ATHMovilEnviroment(payment: payment)
        
        XCTAssertNotNil(enviroment.urlRepresentation().paymentURL)
    }
    
    func testWhenGetURLAppStore_GivenATHMovilEnviroment_ThenATHMovilAppStore(){
        
        let payment = getMockData(business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMClientApp(urlScheme: "test"),
                                  payment: ATHMPayment(total: 1),
                                  timeout: 140)
        
        let enviroment = ATHMovilEnviroment(payment: payment)
        
        XCTAssertEqual(enviroment.appStoreURL, URL(string: "itms://itunes.apple.com/sg/app/ath-movil/id658539297?l=zh&mt=8")!)
    }
    
    //MARK:- Negative
    
    func testWhenGetURlRepresentation_GivenExceptionWhileEncode_ThenGetAnError(){
        
        let payment = AnyPaymentRequestCoder(business: ExceptionCoderMock(),
                                             client: ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: "test")),
                                             payment: PaymentCoder(payment: ATHMPayment(total: 1)),
                                             timeout: 120)
        
        let enviroment = ATHMovilEnviroment(payment: payment)
        
        XCTAssertNotNil(enviroment.urlRepresentation().error)
    }
    
    func testWhenGetURlRepresentation_GivenExceptionWhileEncode_ThenGetAnSourceRequestInError(){
        
        let payment = AnyPaymentRequestCoder(business: ExceptionCoderMock(),
                                             client: ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: "test")),
                                             payment: PaymentCoder(payment: ATHMPayment(total: 1)),
                                             timeout: 120)
        
        let enviroment = ATHMovilEnviroment(payment: payment)
        
        XCTAssertEqual(enviroment.urlRepresentation().error?.source, .request)
    }
    
    func testWhenGetURlRepresentation_GivenExceptionWhileEncode_ThenURLIsNil(){
        
        let payment = AnyPaymentRequestCoder(business: ExceptionCoderMock(),
                                             client: ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: "test")),
                                             payment: PaymentCoder(payment: ATHMPayment(total: 1)),
                                             timeout: 120)
        
        let enviroment = ATHMovilEnviroment(payment: payment)
        
        XCTAssertNil(enviroment.urlRepresentation().paymentURL)
    }
    
    //MARK:- Boundary
    
    
    func testWhenGetURlRepresentation_GivenUnexpectedAppStoreURL_ThenGetAnURL(){
        
        let payment = getMockData(business: ATHMBusinessAccount(token: "test"),
                                  client: ATHMClientApp(urlScheme: "test"),
                                  payment: ATHMPayment(total: 1),
                                  timeout: 140)
        
        let enviroment = EnviromentMock(payment: payment,
                                        athMovilURL: "This is not a url")
        
         XCTAssertNil(enviroment.urlRepresentation().paymentURL)
    }
    
    func testWhenGetURlRepresentation_GivenExceptionWhileEncodePayment_ThenGetAnATHMPaymentError(){
        
        let payment = AnyPaymentRequestCoder(business: ExceptionCoderMock(),
                                             client: ClientAppCoder(clientAPP: ATHMClientApp(urlScheme: "test")),
                                             payment: PaymentCoder(payment: ATHMPayment(total: -1)),
                                             timeout: 120)
        
        let enviroment = ATHMovilEnviroment(payment: payment)
        
        XCTAssertNotNil(enviroment.urlRepresentation().error)
    }
    
    //MARK:- MockData
    
    func getMockData(business: ATHMBusinessAccount, client: ATHMClientApp, payment: ATHMPayment, timeout: Double) -> RequestType{
        
        return RequestType(business: BusinessAccountCoder(business: business),
                           client: ClientAppCoder(clientAPP: client),
                           payment: PaymentCoder(payment: payment),
                           timeout: timeout)
    }
    
}

