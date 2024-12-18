//
//  ResultExtensionUT.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 2/8/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout


private struct TestModel: Model, Equatable {
    let name: String
}


class ResultExtensionUT: XCTestCase{
    
    //MARK:- Positive
    
    func testWhenDecodingResult_GivenData_ThenDecodeToObject() {
        let testObject = TestModel(name: "test")
        let givenData = try! TestModel.encoder.encode(testObject)
        
        let result: Result<Data, Error> = .success(givenData)
        
        result.decoding(TestModel.self) { result in
            
            switch result {
                case .success(let object):
                    XCTAssertEqual(testObject, object)
                    
                default:
                    XCTAssert(false)
            }
            
        }
    }
    
    //MARK:- Negative
    
    func testWhenDecodingResult_GivenDataWithAnObject_ThenFailDecodeAsDecodingError() {
        
        let giveData = "Hola Mundo".data(using: .utf8)
        let result: Result<Data, Error> = .success(giveData!)
        
        result.decoding(TestModel.self) { result in
            
            switch result {
                case .failure(let error):
                    XCTAssert(true)
                default:
                    XCTAssert(false)
            }
            
        }
    }

}
