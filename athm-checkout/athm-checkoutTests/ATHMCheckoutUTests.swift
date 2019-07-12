//
//  athm_checkoutTests.swift
//  athm-checkoutTests
//
//  Created by Leonardo Maldonado on 2/20/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import XCTest
@testable import athm_checkout

class ATHMCheckoutUTests: XCTestCase {

    func testWhenConfigure_GivenEmptyTokenOrCallbackURL_ThenThrowCustomAPITokenOrCallbackURLNotProvidedError() {
        
        // Given
        let publicToken = ""
        let callbackURL = ""
        
        // When
        XCTAssertThrowsError(try ATHMCheckout.shared.configure(for: .development, with: publicToken, and: callbackURL)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .apiTokenOrCallbackURLNotProvided)
        }
    }
    
    func testWhenConfigure_GivenATokenAndCallbackURL_ThenSDKIsConfigured() {

        // Given
        let publicToken = "1234"
        let callbackURL = "callback-url"

        // When, Then
        XCTAssertNoThrow(try ATHMCheckout.shared.configure(for: .development, with: publicToken, and: callbackURL))
    }
    
    func testWhenHandleIncomingURL_GivenNoQueryItem_ThenThrowCustomRequiredURLQueryNotFoundError() {
        
        // Given
        let url: URL! = URL(string: "athm://payment/")
        
        // When
        XCTAssertThrowsError(try ATHMCheckout.shared.handleIncomingURL(url: url)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .requiredURLQueryNotFound)
        }
    }
    
    func testWhenHandleIncomingURL_GivenMissingKeysInJSON_ThenThrowCustomDecodingJSONError() {
        
        let dictionary: [String: Any?] = [
            "incorrect": false,
            "status": "Success",
            "referenceNumber": "1000000001",
            "total": 2.50,
            "subtotal": nil,
            "tax": nil,
            "metadata1": nil,
            "metadata2": nil,
            "items": nil
        ]
        
        let jsonString = dictionary.toJSONString?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!

        // Given
        let url = URL(string: "athm://?athm_payment_data=\(jsonString!)")!

        // When
        XCTAssertThrowsError(try ATHMCheckout.shared.handleIncomingURL(url: url)) { error in

            // Then
            XCTAssertEqual(error as! AMErrorType, .decodingJSONException)
        }
    }

    func testWhenHandleIncomingURL_GivenExpectedKeysInJSON_ThenSuccess() {
        
        let dictionary: [String: Any?] = [
            "completed": false,
            "status": "Success",
            "referenceNumber": "1000000001",
            "total": 2.50,
            "subtotal": nil,
            "tax": nil,
            "metadata1": nil,
            "metadata2": nil,
            "items": nil
        ]
        
        let jsonString = dictionary.toJSONString?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        // Given
        let url = URL(string: "athm://?athm_payment_data=\(jsonString!)")!
        
        // When, Then
        XCTAssertNoThrow(try ATHMCheckout.shared.handleIncomingURL(url: url))
    }
    
    func testWhenHandleIncomingURL_GivenSuccessStatus_ThenCallHandleOnCompletePayment() {
        
        let dictionary: [String: Any?] = [
            "completed": true,
            "status": "Success",
            "referenceNumber": "1000000001",
            "total": 2.50,
            "subtotal": nil,
            "tax": nil,
            "metadata1": nil,
            "metadata2": nil,
            "items": nil
        ]
        
        let jsonString = dictionary.toJSONString?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        // Given
        let url = URL(string: "athm://?athm_payment_data=\(jsonString!)")!
        
        let checkoutDelegateSpy = AMCheckoutDelegateSpy()
        
        ATHMCheckout.shared.delegate = checkoutDelegateSpy
        
        // When
        try! ATHMCheckout.shared.handleIncomingURL(url: url)
        
        // Then
        XCTAssertTrue(checkoutDelegateSpy.onCompletedPaymentWasCalled)
    }
    
    func testWhenHandleIncomingURL_GivenTimeOutStatus_ThenCallHandleOnExpiredPayment() {
        
        let dictionary: [String: Any?] = [
            "completed": false,
            "status": "TimeOut",
            "referenceNumber": "1000000001",
            "total": 2.50,
            "subtotal": nil,
            "tax": nil,
            "metadata1": nil,
            "metadata2": nil,
            "items": nil
        ]
        
        let jsonString = dictionary.toJSONString?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        // Given
        let url = URL(string: "athm://?athm_payment_data=\(jsonString!)")!
        
        let checkoutDelegateSpy = AMCheckoutDelegateSpy()
        
        ATHMCheckout.shared.delegate = checkoutDelegateSpy
        
        // When
        try! ATHMCheckout.shared.handleIncomingURL(url: url)
        
        // Then
        XCTAssertTrue(checkoutDelegateSpy.onExpiredPaymentWasCalled)
    }
    
    func testWhenHandleIncomingURL_GivenCanceledStatus_ThenCallHandleOnCanceledPayment() {
        
        let dictionary: [String: Any?] = [
            "completed": false,
            "status": "Canceled",
            "referenceNumber": "1000000001",
            "total": 2.50,
            "subtotal": nil,
            "tax": nil,
            "metadata1": nil,
            "metadata2": nil,
            "items": nil
        ]
        
        let jsonString = dictionary.toJSONString?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        // Given
        let url = URL(string: "athm://?athm_payment_data=\(jsonString!)")!
        
        let checkoutDelegateSpy = AMCheckoutDelegateSpy()
        
        ATHMCheckout.shared.delegate = checkoutDelegateSpy
        
        // When
        try! ATHMCheckout.shared.handleIncomingURL(url: url)
        
        // Then
        XCTAssertTrue(checkoutDelegateSpy.onCancelledPaymentWasCalled)
    }
    
    func testWhenCheckout_GivenNoSDKConfiguration_ThenThrowCustomAPITokenOrCallbackURLNotProvided() {

        // Given
        let payment = try! ATHMPayment(total: 2.50, subtotal: 1.00, tax: 0.60, metadata1: nil, metadata2: nil, items: nil)

        // When
        XCTAssertThrowsError(try ATHMCheckout.shared.checkout(with: payment)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .apiTokenOrCallbackURLNotProvided)
        }
    }
    
    func testWhenCheckout_GivenATHMSchemeFailedToOpen_ThenOpenAppStoreApp() {
        
        // Given
        let mockUIApplication = MockUIApplication(canOpen: false)
        let urlOpener = URLOpener(application: mockUIApplication)
        
        // When
        let url = URL(string: "test://")!
        let alernateURL = URL(string: "appstore://")!
        urlOpener.openWebsite(url: url, alternateURL: alernateURL, completion: nil)
    
        // Then
        XCTAssertEqual(mockUIApplication.count, 2)
    }
    
    func testWhenCheckout_GivenPayment_ThenOpenATHMApp() {
        
        // Given
        let mockUIApplication = MockUIApplication(canOpen: true)
        let urlOpener = URLOpener(application: mockUIApplication)
        let waitForSchemeToOpen = expectation(description: "Open the ATHM")
        waitForSchemeToOpen.expectedFulfillmentCount = 1
        
        // When
        let url = URL(string: "athm://")!
        let alernateURL = URL(string: "appstore://")!
        urlOpener.openWebsite(url: url, alternateURL: alernateURL) { (success) in
            waitForSchemeToOpen.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(waitForSchemeToOpen.expectedFulfillmentCount, 1)
    }
    
    func testWhenScheme_GivenDevelopmentEnvironment_ThenReturnATHMSimulatorURL() {
        
        // Given
        ATHMCheckout.shared.env = .development
        
        // When
        let scheme = ATHMCheckout.shared.env.scheme
        
        // Then
        XCTAssertEqual(scheme, "athm-simulator://")
    }
    
    func testWhenScheme_GivenProductionEnvironment_ThenReturnATHMProductionURL() {
        
        // Given
        ATHMCheckout.shared.env = .production
        
        // When
        let scheme = ATHMCheckout.shared.env.scheme
        
        // Then
        XCTAssertEqual(scheme, "athm://")
    }
    
    func testWhenBGColor_GivenOriginalTheme_ThenReturnOrangeColor() {
        
        // Given
        ATHMCheckout.shared.theme = .original
        
        // When
        let color = ATHMCheckout.shared.theme.bgColor
        
        // Then
        XCTAssertEqual(color, .orange)
    }
    
    func testWhenBGColor_GivenLightTheme_ThenReturnWhiteColor() {
        
        // Given
        ATHMCheckout.shared.theme = .light
        
        // When
        let color = ATHMCheckout.shared.theme.bgColor
        
        // Then
        XCTAssertEqual(color, .white)
    }
    
    func testWhenBGColor_GivenDarkTheme_ThenReturnBlackColor() {
        
        // Given
        ATHMCheckout.shared.theme = .dark
        
        // When
        let color = ATHMCheckout.shared.theme.bgColor
        
        // Then
        XCTAssertEqual(color, .darkGray)
    }
    
    func testWhenTextColor_GivenOriginalTheme_ThenReturnBlackColor() {
        
        // Given
        ATHMCheckout.shared.theme = .original
        
        // When
        let color = ATHMCheckout.shared.theme.textColor
        
        // Then
        XCTAssertEqual(color, .white)
    }
    
    func testWhenTextColor_GivenDarkTheme_ThenReturnBlackColor() {
        
        // Given
        ATHMCheckout.shared.theme = .dark
        
        // When
        let color = ATHMCheckout.shared.theme.textColor
        
        // Then
        XCTAssertEqual(color, .white)
    }
    
    func testWhenTextColor_GivenLightTheme_ThenReturnBlackColor() {
        
        // Given
        ATHMCheckout.shared.theme = .light
        
        // When
        let color = ATHMCheckout.shared.theme.textColor
        
        // Then
        XCTAssertEqual(color, .black)
    }
    
    func testWhenName_GivenOriginalTheme_ThenReturnOriginalString() {
        
        // Given
        ATHMCheckout.shared.theme = .original
        
        // When
        let name = ATHMCheckout.shared.theme.name
        
        // Then
        XCTAssertEqual(name, "Original")
    }
    
    func testWhenName_GivenDarkTheme_ThenReturnDarkString() {
        
        // Given
        ATHMCheckout.shared.theme = .dark
        
        // When
        let name = ATHMCheckout.shared.theme.name
        
        // Then
        XCTAssertEqual(name, "Dark")
    }
    
    func testWhenName_GivenLightTheme_ThenReturnLightString() {
        
        // Given
        ATHMCheckout.shared.theme = .light
        
        // When
        let name = ATHMCheckout.shared.theme.name
        
        // Then
        XCTAssertEqual(name, "Light")
    }
    
    func testWhenInitATHMPayment_GivenSpecialCharsInMetadata1_ThenThrowCustomSpecialCharactersNotAllowedError() {
        
        // Given
        let metadata1 = "&&&"
        
        // When
        XCTAssertThrowsError(try ATHMPayment(total: 2.50, subtotal: 1.00, tax: 0.60, metadata1: metadata1, metadata2: nil, items: nil)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .specialCharactersNotAllowed)
        }
    }
    
    func testWhenInitATHMPayment_GivenSpecialCharsInMetadata2_ThenThrowCustomSpecialCharactersNotAllowedError() {
        
        // Given
        let metadata2 = "&&&"
        
        // When
        XCTAssertThrowsError(try ATHMPayment(total: 2.50, subtotal: 1.00, tax: 0.60, metadata1: nil, metadata2: metadata2, items: nil)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .specialCharactersNotAllowed)
        }
    }
    
    func testWhenInitATHMPayment_GivenAlphanumericInMetadata1_ThenReturnATHMPayment() {
        
        // Given
        let metadata1 = "alphanumeric"
        
        // When, Then
        XCTAssertNoThrow(try ATHMPayment(total: 2.50, subtotal: 1.00, tax: 0.60, metadata1: metadata1, metadata2: nil, items: nil))
    }
    
    func testWhenInitATHMPayment_GivenAlphanumericInMetadata2_ThenReturnATHMPayment() {
        
        // Given
        let metadata2 = "alphanumeric"
        
        // When, Then
        XCTAssertNoThrow(try ATHMPayment(total: 2.50, subtotal: 1.00, tax: 0.60, metadata1: nil, metadata2: metadata2, items: nil))
    }
    
    func testWhenInitATHMPaymentItem_GivenSpecialCharsInMetadata_ThenThrowCustomSpecialCharactersNotAllowedError() {
        
        // Given
        let metadata = "&&&"
        
        // When
        XCTAssertThrowsError(try ATHMPaymentItem(desc: "desc", name: "name", priceNumber: 1.00, quantity: 1, metadata: metadata)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .specialCharactersNotAllowed)
        }
    }
    
    func testWhenInitATHMPaymentItem_GivenSpecialCharsInDescription_ThenThrowCustomSpecialCharactersNotAllowedError() {
        
        // Given
        let desc = "&&&"
        
        // When
        XCTAssertThrowsError(try ATHMPaymentItem(desc: desc, name: "name", priceNumber: 1.00, quantity: 1, metadata: nil)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .specialCharactersNotAllowed)
        }
    }
    
    func testWhenInitATHMPaymentItem_GivenSpecialCharsInName_ThenThrowCustomSpecialCharactersNotAllowedError() {
        
        // Given
        let name = "&&&"
        
        // When
        XCTAssertThrowsError(try ATHMPaymentItem(desc: "desc", name: name, priceNumber: 1.00, quantity: 1, metadata: nil)) { error in
            
            // Then
            XCTAssertEqual(error as! AMErrorType, .specialCharactersNotAllowed)
        }
    }
    
    func testWhenInitATHMPaymentItem_GivenAlphanumericInMetadata_ThenNoThrowSpecialCharactersNotAllowed() {
        
        // Given
        let metadata = "alphanumeric"
        
        // When, Then
        XCTAssertNoThrow(try ATHMPaymentItem(desc: "desc", name: "name", priceNumber: 1.00, quantity: 1, metadata: metadata))
    }
    
    func testWhenInitATHMPaymentItem_GivenAlphanumericInDescription_ThenReturnATHMPaymentItem() {
        
        // Given
        let desc = "alphanumeric"
        
        // When, Then
        XCTAssertNoThrow(try ATHMPaymentItem(desc: desc, name: "name", priceNumber: 1.00, quantity: 1, metadata: nil))
    }
    
    func testWhenInitATHMPaymentItem_GivenAlphanumericInName_ThenReturnATHMPaymentItem() {
        
        // Given
        let name = "alphanumeric"
        
        // When, Then
        XCTAssertNoThrow(try ATHMPaymentItem(desc: "desc", name: name, priceNumber: 1.00, quantity: 1, metadata: nil))
    }
}
