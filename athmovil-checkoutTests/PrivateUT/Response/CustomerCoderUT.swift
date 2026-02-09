//
//  CustomerCoderUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 6/16/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


class CustomerCoderUT: XCTestCase {
    
    
    //MARK:- Positive
    
    func testWhenDecodeCustomerName_GivenNameKey_ThenCanParseName() {
        
        let dic = self.getDataMock(key: "name", value: "Damian")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertEqual(ATHMCustomer?.name, "Damian")
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
    }
    
    func testWhenDecodeCustomerEmail_GivenEmailKey_ThenCanParseEmail(){
       
        let dic = self.getDataMock(key: "email", value: "hola@hola.com")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertEqual(ATHMCustomer?.email, "hola@hola.com")
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
        
    }
    
    func testWhenDecodeCustomerPhone_GivenPhoneKey_ThenCanParsePhone() {
        
        let dic = self.getDataMock(key: "phoneNumber", value: "7771112222")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertEqual(ATHMCustomer?.phoneNumber, "7771112222")
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
        
    }
    
    //MARK:- Negavite
    
    func testWhenDecodeCustomerName_GivenNameKeyEmpty_ThenNameIsEmptyString() {
                
        let dic = self.getDataMock(key: "name", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertTrue(ATHMCustomer?.name.isEmpty ?? false)
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
        
    }
    
    func testWhenDecodeCustomerEmail_GivenEmailKeyEmpty_ThenEmailIsEmpty() {
        
        let dic = self.getDataMock(key: "email", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertTrue(ATHMCustomer?.email.isEmpty ?? false)
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
    }
    
    func testWhenDecodeCustomerPhone_GivenPhoneKeyEmpty_ThenPhoneNumberIsZero() {
        
        let dic = self.getDataMock(key: "phoneNumber", value: "")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertEqual(ATHMCustomer?.phoneNumber, "")
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
    }
    

    //MARK:- Boundary
    
    
    func testWhenDecodeCustomerName_GivenDictionaryWithoutKeyName_ThenNameIsEmptyString(){
                
        var dic = self.getDataMock(key: "name", value: "")
        dic.removeValue(forKey: "name")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertTrue(ATHMCustomer?.name.isEmpty ?? false)
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
    }
    
    func testWhenDecodeCustomerEmail_GivenDictionaryWithoutKeyEmail_ThenEmailIsEmpty(){
        
        var dic = self.getDataMock(key: "email", value: "")
        dic.removeValue(forKey: "email")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertTrue(ATHMCustomer?.email.isEmpty ?? false)
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
    }
    
    func testWhenDecodeCustomerPhone_GivenDictionaryWithoutKeyPhoneNumber_ThenPhoneNumberIsZero(){
        
        var dic = self.getDataMock(key: "phoneNumber", value: "")
        dic.removeValue(forKey: "phoneNumber")
        
        do {
            try XCTAssertDecode(codable: ATHMCustomer.self, from: dic) { (ATHMCustomer: ATHMCustomer?) in
                XCTAssertEqual(ATHMCustomer?.phoneNumber, "")
            }
        } catch {
            XCTFail("Error decodificando ATHMCustomer: \(error)")
        }
    }
    
    func testWhenDecodeCustomer_GivenUnexpectedData_ThenThrowsAnException() {
        
        let dataUnexpected = "[]".toData

        XCTAssertThrowsError(try JSONDecoder().decode(ATHMCustomer.self, from: dataUnexpected!)) {
            (error) in
            XCTAssertTrue(error is ATHMPaymentError)
        }
    }
    
    func testWhenDecodeCustomer_GivenUnexpectedData_ThenThrowsAnExceptionWithSourceResponse() {
        
        let dataUnexpected = "[]".toData

        XCTAssertThrowsError(try JSONDecoder().decode(ATHMCustomer.self, from: dataUnexpected!)) {
            (error) in
            
            let ahtMovilError = error as? ATHMPaymentError
            XCTAssertEqual(ahtMovilError!.source, .response)
        }
    }
    
    // MARK:- MockData
    
    func getDataMock(key: String, value: Any?) -> [String : Any?] {
        var dicMock: [String: Any?] = ["name": "test", "phoneNumber": "7874531893", "email": "test@evertecinc.com"]
    
        dicMock[key] = value
        return dicMock
    }
}
