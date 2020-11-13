//
//  URLOpenerUT.swift
//  athm-checkoutTests
//
//  Created by Leonardo Maldonado on 2/20/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import XCTest
@testable import athmovil_checkout

class URLOpenerUT: XCTestCase {

    
    func testWhenOpenWebsite_GivenATHMSchemeFailedToOpen_ThenOpenAppStoreApp() {
        
        // Given
        let mockUIApplication = MockUIApplication(canOpen: false)
        let urlOpener = URLOpener(application: mockUIApplication)

        
        // When 
        let url = URL(string: "test://")!
        let alernateURL = URL(string: "appstore://")!
        urlOpener.openWebsite(url: url, alternateURL: alernateURL, options: [:], completion: nil)
    
        // Then
        XCTAssertEqual(mockUIApplication.count, 2)
    }
    
    func testWhenOpenWebsite_GivenPayment_ThenOpenATHMApp() {
        
        // Given
        let mockUIApplication = MockUIApplication(canOpen: true)
        let urlOpener = URLOpener(application: mockUIApplication)
        let waitForSchemeToOpen = expectation(description: "Open the ATHM")
        waitForSchemeToOpen.expectedFulfillmentCount = 1
        
        // When
        let url = URL(string: "athm://")!
        let alernateURL = URL(string: "appstore://")!
        urlOpener.openWebsite(url: url, alternateURL: alernateURL, options: [:]) { (success) in
            waitForSchemeToOpen.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(waitForSchemeToOpen.expectedFulfillmentCount, 1)
    }
    
}
