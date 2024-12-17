//
//  AuthorizationResponseCodable.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 15/09/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

protocol AuthorizationResponse: Model { }

// MARK: - AuthorizationResponseCodable
struct AuthorizationResponseCodable: AuthorizationResponse {
    let status:ATHMAuthorizationResponse.TypeStatus
    let data: PaymentData
    let message: String?
}

// MARK: - PaymentData
public struct PaymentData: Codable {
    let dailyTransactionId, referenceNumber: String
    let fee, netAmount: Double

    enum CodingKeys: String, CodingKey {
        case dailyTransactionId, referenceNumber, fee, netAmount
    }
}
