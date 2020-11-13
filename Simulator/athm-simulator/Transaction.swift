//
//  Transaction.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct TransactionRequest: Codable {
    let publicToken: String
    let scheme: String
    let subtotal: Double
    let expiresIn: Double
    let tax: Double
    let total: Double
    let metadata1: String
    let metadata2: String
    let items: [TransactionItem] = [TransactionItem(desc: "",
                                                    name: "Item Name",
                                                    price: 1,
                                                    quantity: 1,
                                                    metadata: "Test Metadata")]
}

struct TransactionResponse: Codable {
    let status: String
    let date: String
    let referenceNumber: String
    let dailyTransactionID: Int
    let subtotal: Double
    let tax: Double
    let total: Double
    let fee: Double
    let netAmount: Double
    let name: String
    let email: String
    let phoneNumber: String
    let metadata1: String
    let metadata2: String
    let items: [TransactionItem]
    let version: String
}

