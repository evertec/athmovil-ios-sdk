//
//  XCTest.swift
//  athmovil_checkoutIntegrationTests
//
//  Created by Hansy on 12/22/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import XCTest
@testable import athmovil_checkout

extension XCTestCase {
    
    
    func XCTAssertDecode<D>(codable: D.Type, from dictionary: [String: Any?],
                            assert: (_ response: D?) -> Void) throws where D : Decodable{
        
        let responseData = dictionary.toJSONString?.toData
        
        do {
            let decodableResponse = try JSONDecoder().decode(D.self, from: responseData!)
            assert(decodableResponse)
            
        } catch let exc {
            throw exc
        }
    }
    
    func XCTAssertEncode<E>(encode: E, assert: (_ response: [String: Any?]) -> Void) throws where E : Encodable{
        
        do {
            let encodableData = try JSONEncoder().encode(encode.self)
            let objectDic = String(data: encodableData, encoding: String.Encoding.utf8)?.toJSON
            
            assert(objectDic ?? ["":""])
            
        } catch let exc {
            throw exc
        }
    }
}
