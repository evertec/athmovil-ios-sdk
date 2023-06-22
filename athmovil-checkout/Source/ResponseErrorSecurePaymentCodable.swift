//
//  ResponseErrorSecurePaymentCodable.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 15/09/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

protocol ResponseErrorSecurePayment: Model { }

// MARK: - ResponseErrorSecurePaymentCodable
struct ResponseErrorSecurePaymentCodable: ResponseErrorSecurePayment {
    let status, message, errorcode: String
    let data: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

