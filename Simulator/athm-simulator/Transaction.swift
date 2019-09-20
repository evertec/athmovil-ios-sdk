//
//  Transaction.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct Transaction {
    let publicToken: String
    let scheme: String?
    let subtotal: Double?
    let expiresIn: Double?
    let tax: Double?
    let total: Double
    let metadata1: String?
    let metadata2: String?
    let items: [TransactionItem]?
}

extension Transaction {
    init?(json: [String: Any]) {
        
        // Required params
        guard let publicToken = json["publicToken"] as? String,
              let total = json["total"] as? Double
        else {
            return nil
        }
        
        // Optional params
        let scheme = json["scheme"] as? String
        let subtotal = json["subtotal"] as? Double
        let tax = json["tax"] as? Double
        let expiresIn = json["expiresIn"] as? Double
        let metadata1 = json["metadata1"] as? String
        let metadata2 = json["metadata2"] as? String
        
        var items: [TransactionItem] = []
        if let itemsSelectedList = json["items"] as? [Dictionary<String, Any>] {
            
            for item in itemsSelectedList {
                guard let desc = item["desc"] as? String,
                      let name = item["name"] as? String,
                      let price = item["price"] as? Double,
                      let quantity = item["quantity"] as? Int,
                      let metadata = item["metadata"] as? String
                else {
                    return nil
                }
                
                let transactionItem = TransactionItem(
                    desc: desc, name: name, price:
                    price, quantity: quantity, metadata: metadata)
                
                items.append(transactionItem)
            }
        }
        
        self.publicToken = publicToken
        self.scheme = scheme
        self.subtotal = subtotal
        self.expiresIn = expiresIn
        self.tax = tax
        self.total = total
        self.metadata1 = metadata1
        self.metadata2 = metadata2
        self.items = items
    }
}
