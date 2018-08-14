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
                image: UIImage(named: "dummy-image-0")!,
                desc: "(6oz)",
                name: "Blueberries",
                price: "3.99",
                quantity: "1"),
            TransactionItem(
                image: UIImage(named: "dummy-image-1")!,
                desc: "(6oz)",
                name: "Raspberries",
                price: "2.75",
                quantity: "1")
        ]
    }
    
    static let dummyTransaction = Transaction(
        businessToken: "fb1f7ae2849a07da1545a89d997d8a435a5f21ac",
        scheme: "athm-checkout",
        cartReferenceId: "0987654321",
        subTotal: "1.50",
        tax: "3.42",
        total: "3.92",
        itemList: dummyTransactionItemList)
}
