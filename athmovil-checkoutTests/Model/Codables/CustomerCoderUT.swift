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


class CustomerCoderUT: XCTestCase{
    
    
    //MARK:- Positive
    
    func testWhenDecodeCustomerName_GivenNameKey_ThenCanParseName(){
        
        let dic = self.getDataMock(key: "name", value: "Damian")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertEqual(customerCoder?.customer.name, "Damian")
        }
    }
    
    func testWhenDecodeCustomerEmail_GivenEmailKey_ThenCanParseEmail(){
        
        let dic = self.getDataMock(key: "email", value: "hola@hola.com")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertEqual(customerCoder?.customer.email, "hola@hola.com")
        }
        
    }
    
    func testWhenDecodeCustomerPhone_GivenPhoneKey_ThenCanParsePhone(){
        
        let dic = self.getDataMock(key: "phoneNumber", value: "7771112222")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertEqual(customerCoder?.customer.phoneNumber, "7771112222")
        }
        
    }
    
    //MARK:- Negavite
    
    func testWhenDecodeCustomerName_GivenNameKeyEmpty_ThenNameIsEmptyString(){
                
        let dic = self.getDataMock(key: "name", value: "")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertTrue(customerCoder?.customer.name.isEmpty ?? false)
        }
        
    }
    
    func testWhenDecodeCustomerEmail_GivenEmailKeyEmpty_ThenEmailIsEmpty(){
        
        let dic = self.getDataMock(key: "email", value: "")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertTrue(customerCoder?.customer.email.isEmpty ?? false)
        }
    }
    
    func testWhenDecodeCustomerPhone_GivenPhoneKeyEmpty_ThenPhoneNumberIsZero(){
        
        let dic = self.getDataMock(key: "phoneNumber", value: "")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertEqual(customerCoder?.customer.phoneNumber, "")
        }
    }
    

    //MARK:- Boundary
    
    
    func testWhenDecodeCustomerName_GivenDictionaryWithoutKeyName_ThenNameIsEmptyString(){
                
        var dic = self.getDataMock(key: "name", value: "")
        dic.removeValue(forKey: "name")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertTrue(customerCoder?.customer.name.isEmpty ?? false)
        }
    }
    
    func testWhenDecodeCustomerEmail_GivenDictionaryWithoutKeyEmail_ThenEmailIsEmpty(){
        
        var dic = self.getDataMock(key: "email", value: "")
        dic.removeValue(forKey: "email")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertTrue(customerCoder?.customer.email.isEmpty ?? false)
        }
    }
    
    func testWhenDecodeCustomerPhone_GivenDictionaryWithoutKeyPhoneNumber_ThenPhoneNumberIsZero(){
        
        var dic = self.getDataMock(key: "phoneNumber", value: "")
        dic.removeValue(forKey: "phoneNumber")
        
        try! XCTAssertDecode(codable: CustomerCoder.self, from: dic) { (customerCoder: CustomerCoder?) in
            XCTAssertEqual(customerCoder?.customer.phoneNumber, "")
        }
    }
    
    func testWhenDecodeCustomer_GivenUnexpectedData_ThenThrowsAnException() {
        
        let dataUnexpected = "[]".toData

        XCTAssertThrowsError(try JSONDecoder().decode(CustomerCoder.self, from: dataUnexpected!)) {
            (error) in
            XCTAssertTrue(error is ATHMPaymentError)
        }
    }
    
    func testWhenDecodeCustomer_GivenUnexpectedData_ThenThrowsAnExceptionWithSourceResponse() {
        
        let dataUnexpected = "[]".toData

        XCTAssertThrowsError(try JSONDecoder().decode(CustomerCoder.self, from: dataUnexpected!)) {
            (error) in
            
            let ahtMovilError = error as? ATHMPaymentError
            XCTAssertEqual(ahtMovilError!.source, .response)
        }
    }
    
    
    //MARK:- MockData
    
    func getDataMock(key: String, value: Any?) -> [String : Any?] {
        var dicMock: [String: Any?] = ["name": "test", "phoneNumber": "7874531893", "email": "test@evertecinc.com"]
        
        dicMock[key] = value
        return dicMock
    }
    
}

