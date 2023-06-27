//
//  TargetURLRepresentableUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


extension TargetURLScheme: CaseIterable {
    public static var allCases: [TargetURLScheme] { [.athMovil(.production), .athMovilSimulated(.production), .athMovilSecure(.production)] }
}

extension TargetUniversalLinks: CaseIterable {
    public static var allCases: [TargetUniversalLinks] { [.athMovil(.production), .athMovilSimulated(.production), .athMovilSecure(.production)] }
}

class TargetURLRepresentableUT: XCTestCase {
    

    //MARK:- Positive
    
    func testWhenGetURLRepresentation_GivenAllTargetsURLScheme_ThenGetAValidURLOfRequest() {
        
        TargetURLScheme.allCases.forEach { currentCase in
            let codableString = "URLSchemeExample"
        
            let result = currentCase.urlRepresentation(codableString)
            
            switch result {
                case let .success(URL):
                    XCTAssertNotNil(URL)
                case .failure:
                    XCTAssertNil(false)
            }
        }
    }
    
    func testWhenGetURLRepresentation_GivenAllTargetsUniversalLinks_ThenGetAValidURLOfRequest() {
        
        TargetUniversalLinks.allCases.forEach { currentCase in
            let codableString = "UniversalSchemeExample"
            
            let result = currentCase.urlRepresentation(codableString)
            
            switch result {
                case let .success(URL):
                    XCTAssertNotNil(URL)
                case .failure:
                    XCTAssertNil(false)
            }
        }
    }
    
    func testWhenGetAppStoreURL_GivenTargetURLScheme_ThenTHMovilHasAnAppStoreURL() {
        TargetURLScheme.allCases.forEach {
            XCTAssertEqual($0.appStoreURL, URL(string: "itms://itunes.apple.com/sg/app/ath-movil/id658539297?l=zh&mt=8")!)
        }
    }
    
    func testWhenGetAppStoreURL_GivenTargetUniversalLinks_ThenTHMovilHasAnAppStoreURL() {
        TargetUniversalLinks.allCases.forEach {
            XCTAssertEqual($0.appStoreURL, URL(string: "itms://itunes.apple.com/sg/app/ath-movil/id658539297?l=zh&mt=8")!)
        }
    }
    
    //MARK:- Negative
    
    func testWhenGetURLRepresentation_GivenAnExceptionObjectInTargetURLScheme_ThenGetAnATHMPaymentError() {
        
        TargetURLScheme.allCases.forEach { currentCase in
            let objectException = ExceptionCoderMock()
            
            let result = currentCase.urlRepresentation(objectException)
            
            switch result {
                case .success:
                    XCTAssert(false)
                case .failure:
                    XCTAssert(true)
            }
        }
    }
    
    func testWhenGetURLRepresentation_GivenAnExceptionObjectInTargetUniversalLinks_ThenGetAnATHMPaymentError() {
        
        TargetUniversalLinks.allCases.forEach { currentCase in
            let objectException = ExceptionCoderMock()
            
            let result = currentCase.urlRepresentation(objectException)
            
            switch result {
                case .success:
                    XCTAssert(false)
                case .failure:
                    XCTAssert(true)
            }
        }
    }
    
    //MARK:- Boundary
        
    func testWhenGetURLRepresentation_GivenAnyTargetObject_ThenGetAnATHMPaymentError() {
        
        let anyEncodable = "Any Object Codable"
        let target = TargetMock(payment: anyEncodable, athMovilURL: "This is not a url")
        
        let result = target.urlRepresentation(anyEncodable)
        
        switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false)
        }

    }
        
}

