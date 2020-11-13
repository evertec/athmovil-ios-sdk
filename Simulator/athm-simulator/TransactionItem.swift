//
//  TransactionItem.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct TransactionItem: Codable{
    let desc: String
    let name: String
    let price: Double
    let quantity: Int
    let metadata: String
}

extension TransactionItem {
    var toDictionary: [String: Any] {
        return [
            "desc": desc,
            "name": name,
            "price": price,
            "quantity": quantity,
            "metadata": metadata
        ]
    }
}

