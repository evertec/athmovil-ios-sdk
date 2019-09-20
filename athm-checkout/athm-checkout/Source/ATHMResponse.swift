//
//  AMResponse.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

public enum ATHMStatus: String, Codable {
    case success
    case unavailable
    case canceled
    case noActiveCards
    case timeout
    case other

    public init(rawValue: String) {
        switch rawValue {
        case "Success":
            self = .success
        case "BusinessUnavailable":
            self = .unavailable
        case "Canceled":
            self = .canceled
        case "UserHaveNoActiveCards":
            self = .noActiveCards
        case "TimeOut":
            self = .timeout
        default:
            self = .other
        }
    }
}

@objcMembers
class ATHMResponse: NSObject, Codable {
    let completed: Bool
    let status: ATHMStatus
    var referenceNumber: String?
    let dailyTransactionId: String?
    let transactionReference: String?
    let total: Double
    let subtotal: Double?
    var tax: Double?
    let metadata1: String?
    let metadata2: String?
    let items: [ATHMPaymentItem]?
}
