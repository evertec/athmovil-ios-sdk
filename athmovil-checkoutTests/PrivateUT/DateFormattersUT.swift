//
//  DateFormattersUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/4/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class DateFormattersUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenGetDecodableFormatter_GivenInstanceOfDateFormatters_ThenDataFormatterHasADefaultFormat(){
        
        let dateFormatter = DateFormatters.codable
        
        XCTAssertEqual(dateFormatter.dateFormat, "yyyy/MM/dd HH:mm:ss.S")
    }
    
    func testWhenGetDecodableFormatter_GivenInstanceOfDateFormatters_ThenDefatulTimeZoneIsInPuertoRico(){
        
        let dateFormatter = DateFormatters.codable
        
        XCTAssertEqual(dateFormatter.timeZone, TimeZone(identifier: "America/Puerto_Rico"))
    }
    
    //MARK:- Boundary
    
    func testWhenConvertStringToDate_GivenDateInOtherTimeZone_ThenUseDefaultTimeZone(){
        
        let dateFromAnotherCountry = Date(timeIntervalSince1970: 1607110979)
        
        let dateInTimePuertoRico = DateFormatters.codable.string(from: dateFromAnotherCountry)
        
        XCTAssertEqual(dateInTimePuertoRico, "2020/12/04 15:42:59.0")
    }
}
