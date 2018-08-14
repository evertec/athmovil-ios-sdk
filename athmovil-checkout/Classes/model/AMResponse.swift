//
//  AMResponse.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

//struct AMResponse: Codable {
//    let success: Bool
//    let error: String
//    let referenceId: String
//    let errorDescription: String
//
//    enum CodingKeys: String, CodingKey {
//        case success = "success"
//        case referenceId = "reference_id"
//        case error = "error"
//        case errorDescription = "error_description"
//    }
//}

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
