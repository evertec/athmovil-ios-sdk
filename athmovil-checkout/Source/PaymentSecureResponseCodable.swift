//
//  SecurePaymentStatusCodable.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 15/09/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

protocol PaymentSecureResponse: Model { }

// MARK: - ResponseSecurePaymentCodable
struct PaymentSecureResponseCodable: PaymentSecureResponse {
    let status: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let ecommerceID, authToken: String

    enum CodingKeys: String, CodingKey {
        case ecommerceID = "ecommerceId"
        case authToken = "auth_token"
    }
}
