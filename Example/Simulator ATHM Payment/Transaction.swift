//
//  Transaction.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct Transaction {
    let token: String
    let scheme: String?
    let subTotal: String?
    let expiresIn: Double?
    let tax: String?
    let total: String
    let cartReferenceId: String
    let items: [TransactionItem]?
}

extension Transaction {
    init?(json: [String: Any]) {
        
        // Required params
        guard let token = json["businessToken"] as? String,
            let total = json["total"] as? String,
            let cardReferenceId = json["cartReferenceId"] as? String
            else { return nil }
        
        // Optional params
        let scheme = json["scheme"] as? String
        let subTotal = json["subTotal"] as? String
        let tax = json["tax"] as? String
        let expiresIn = json["expiresIn"] as? Double
        
        var items: [TransactionItem] = []
        if let itemsSelectedList = json["itemsSelectedList"]
            as? [Dictionary<String, Any>] {
            
            for item in itemsSelectedList {
                guard let description = item["description"] as? String,
                    let name = item["name"] as? String,
                    let price = item["price"] as? String,
                    let quantity = item["quantity"] as? String
                    else { return nil }
                
                let transactionItem = TransactionItem(
                    description: description, name: name, price:
                    price, quantity: quantity)
                
                items.append(transactionItem)
            }
        }
        
        self.token = token
        self.scheme = scheme
        self.subTotal = subTotal
        self.expiresIn = expiresIn
        self.tax = tax
        self.total = total
        self.cartReferenceId = cardReferenceId
        self.items = items
    }
}
