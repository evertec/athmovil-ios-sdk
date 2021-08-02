//
//  ATHMResponseDeprecated.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 6/16/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

struct ATHMResponseDeprecated: Codable {
    
    enum ATHMStatusDeprecated: String, Codable {
        case success = "Success",
        canceled = "TimeOut",
        timeout = "Canceled"

        public init(rawValue: String) {
            switch rawValue {
                case "Success":
                    self = .success
                case "TimeOut":
                    self = .timeout
                default:
                    self = .canceled
            }
        }
    }
    
    let status: ATHMStatusDeprecated
    let referenceNumber: String?
    let dailyTransactionId: String?
    let transactionReference: String?
    
    /// Convert ATHMStatus to ATHMStatusPayment
    /// - Returns: the new type of status
    func convertToCurrentStatus() -> ATHMStatus {
        switch self.status {
            case .success:
                return .completed
            case .timeout:
                return .expired
            default:
                return .cancelled
        }
    }
}
