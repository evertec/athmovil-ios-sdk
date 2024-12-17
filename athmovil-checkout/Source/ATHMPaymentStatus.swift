//
//  ATHMPaymentStatus.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

enum ATHMStatus: String, Codable {
    case completed,
    cancelled,
    expired,
    failed
}

enum ATHMVersion: String, Codable {
    case three = "3.0"
}

@objc(ATHMPaymentStatus)
final public class ATHMPaymentStatus: NSObject {
        
    /// Status of the transacion
    var status: ATHMStatus
    
    /// Version of the transacion
    var version: ATHMVersion?
    
    /// State of the payment it could be completed, expired or cancelled
    @objc public var statusPayment: String { status.rawValue.uppercased() }
    
    /// Date of the the transaction, it means the date and time of the application of the transaction
    @objc public let date: Date

    /// Reference number of the transacction, if the transaction is completed has a value otherwise nil
    @objc public var referenceNumber: String
    
    /// Consecutive number of the trasaction, if the transaction is completed has a value otherwise nil
    @objc public var dailyTransactionID: Int
            
    @objc override public var description: String {
        """
        Status:
            - status: \(statusPayment)
            - date: \(date)
            - referenceNumber: \(referenceNumber)
            - dailyTransactionID: \(dailyTransactionID)
        """
    }
    
    required init(reference: String, dayliId: Int, date: Date, status: ATHMStatus) {
        self.referenceNumber = reference
        self.dailyTransactionID = dayliId
        self.date = date
        self.status = status
    }
        
    init(status: ATHMStatus) {
        self.status = status
        self.referenceNumber = ""
        self.dailyTransactionID = 0
        self.date = Date()
    }
}
