//
//  Transaction.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/3/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation
import UIKit

struct Transaction {
    let businessToken: String
    let scheme: String
    let cartReferenceId: String
    let subTotal: String
    let tax: String
    let total: String
    var itemList: [TransactionItem]
}

extension Transaction {
    static var dummyTransactionItemList: [TransactionItem] {
        return [
            TransactionItem(
                image: UIImage(named: "p1")!,
                desc: "Black and Gray",
                name: "Shirt",
                price: "20.00",
                quantity: "1"),
            TransactionItem(
                image: UIImage(named: "p3")!,
                desc: "Black",
                name: "Pants",
                price: "50.00",
                quantity: "1"),
            TransactionItem(
                image: UIImage(named: "p2")!,
                desc: "Tan bots",
                name: "Shoes",
                price: "30.00",
                quantity: "1")
        ]
    }
    
    static let dummyTransaction = Transaction(
        businessToken: "fb1f7ae2849a07da1545a89d997d8a435a5f21ac",
        scheme: "athm-checkout",
        cartReferenceId: "0987654321",
        subTotal: "100.00",
        tax: "11.50",
        total: "111.50",
        itemList: dummyTransactionItemList)
}
