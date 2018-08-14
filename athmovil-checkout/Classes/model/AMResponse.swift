//
//  AMResponse.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

enum AMStatus: String, Codable {
    case success
    case unavailable
    case canceled
    case noActiveCards
    case timeout
    case other

    init(rawValue: String){
        switch rawValue {
        case "Success": self = .success
        case "BusinessUnavailable": self = .unavailable
        case "Canceled": self = .canceled
        case "UserHaveNoActiveCards": self = .noActiveCards
        case "TimeOut": self = .timeout
        default: self = .other
        }
    }
}

struct AMResponse: Codable {
    let completed: Bool
    let status: AMStatus
    let cartReferenceId: String
    let dailyTransactionId: String?
    let transactionReference: String?
}
