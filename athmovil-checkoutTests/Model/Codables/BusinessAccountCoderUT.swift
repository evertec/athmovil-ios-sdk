//
//  BusinessAccountCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 7/28/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class BusinessAccountCoderUT: XCTestCase{
    
    //MARK:- Positive
    
    
    func testWhenEncodeBusinessAccount_GivenToken_ThenEncodeTheBusinessAccount(){
        
        let businessAccount = BusinessAccountCoder(business: ATHMBusinessAccount(token: "12345"))
        
        try! XCTAssertEncode(encode: businessAccount) { (dicResponse) in
            XCTAssertEqual(dicResponse["publicToken"] as? String, "12345")
        }
        
    }
    
    
    //MARK:- Negative
    
    func testWhenEncodeBusinessAccount_GivenEmptyToken_ThenThrowsAnException(){
        
        let businessAccount = BusinessAccountCoder(business: ATHMBusinessAccount(token: ""))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: businessAccount,
                                                 assert: { (responseDic) in
            XCTAssert(false)
                                                    
        })) {
            XCTAssertTrue($0 is ATHMPaymentError)
        }
    }

    
    func testWhenEncodeBusinessAccount_GivenEmptyToken_ThenThrowExceptionInRequest(){
        
        let businessAccount = BusinessAccountCoder(business: ATHMBusinessAccount(token: ""))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: businessAccount,
                                                 assert: { (responseDic) in
            XCTAssert(false)
                                                    
        })) { error in
            let exceptionPayment = error as? ATHMPaymentError
            XCTAssertEqual(exceptionPayment?.source, .request)
        }
    }
    
    func testWhenEncodeBusinessAccount_GivenEmptyToken_ThenExceptionHasADescription(){
        
        let businessAccount = BusinessAccountCoder(business: ATHMBusinessAccount(token: ""))
        
        XCTAssertThrowsError(try XCTAssertEncode(encode: businessAccount,
                                                 assert: { (responseDic) in
            XCTAssert(false)
                                                    
        })) {
            let exceptionPayment = $0 as? ATHMPaymentError
            XCTAssertEqual(exceptionPayment?.failureReason, "The business's token is required")
        }
    }
    
    
    //MARK:- Boundary
    
    
}

