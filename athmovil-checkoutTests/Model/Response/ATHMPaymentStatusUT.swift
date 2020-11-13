//
//  ATHMPaymentStatusUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class ATHMPaymentStatusUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenInitPaymentStatus_GivenReference_ThenStatusHasReference(){
        
        let paymentStatus = ATHMPaymentStatus(reference: "12345", dayliId: 1, date: Date(), status: .completed)
        XCTAssertEqual(paymentStatus.referenceNumber, "12345")
    }
    
    func testWhenInitPaymentStatus_GivenDayliId_ThenStatusHasDayliID(){
        
        let paymentStatus = ATHMPaymentStatus(reference: "12345", dayliId: 1, date: Date(), status: .completed)
        XCTAssertEqual(paymentStatus.dailyTransactionID, 1)
    }
    
    func testWhenInitPaymentStatus_GivenDate_ThenStatusHasDate(){
        
        let date = Date()
        let paymentStatus = ATHMPaymentStatus(reference: "12345", dayliId: 1, date: date, status: .completed)
        XCTAssertEqual(paymentStatus.date, date)
    }
    
    func testWhenInitPaymentStatus_GivenCompleted_ThenStatusHasCompletedStatus(){
        
        let paymentStatus = ATHMPaymentStatus(reference: "12345", dayliId: 1, date: Date(), status: .completed)
        XCTAssertEqual(paymentStatus.status, .completed)
    }
    
    func testWhenGetDescription_GivenPayment_ThenPrintPaymentStatus(){
        let paymentStatus = ATHMPaymentStatus(reference: "12345", dayliId: 1, date: Date(), status: .completed)
        XCTAssertFalse(paymentStatus.description.isEmpty)
    }
    
    //MARK:- Negative
    
    func testWhenGetDescription_GivenPaymentWithEmptyProperties_ThenPrintPaymentStatus(){
        let paymentStatus = ATHMPaymentStatus(reference: "", dayliId: 0, date: Date(), status: .completed)
        XCTAssertFalse(paymentStatus.description.isEmpty)
    }
    
    //MARK:- Boundary
    
}

