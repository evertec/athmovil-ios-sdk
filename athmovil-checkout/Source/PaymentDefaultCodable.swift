//
//  PaymentDefaultCodable.swift
//  athmovil-checkout
//
//  Created by Hansy on 12/16/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol Model: Codable {
    static var decoder: JSONDecoder { get }
    static var encoder: JSONEncoder { get }
}

extension Model {
    static var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatters.codable)
        return jsonDecoder
    }
    
    static var encoder: JSONEncoder {
        let jsonDecoder = JSONEncoder()
        jsonDecoder.dateEncodingStrategy = .formatted(DateFormatters.codable)
        return jsonDecoder
    }
}

extension Data: Model {}
