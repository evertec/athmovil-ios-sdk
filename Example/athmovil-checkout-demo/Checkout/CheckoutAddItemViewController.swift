//
//  CheckoutAddItemViewController.swift
//  athmovil-checkout-demo
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import UIKit
import athmovil_checkout

class CheckoutAddItemViewController: UITableViewController{
    
    @IBOutlet var textFieds: [UITextField]!
    
    var onCompleted: ((ATHMPaymentItem)->())?
    
    @IBAction func done(_ sender: Any) {
        
        self.view.endEditing(true)
        
        var name = ""; var desc = ""; var metadata = ""
        var price = 0.0; var quantity = 0
        
        for (index, currentTextField) in self.textFieds.enumerated() {
            
            switch index {
                case 0:
                    name = currentTextField.text ?? ""
                case 1:
                    price = Double(currentTextField.text ?? "0.0") ?? 0.0
                case 2:
                    quantity = Int(currentTextField.text ?? "0") ?? 0
                case 3:
                    desc = currentTextField.text ?? ""
                case 4:
                    metadata = currentTextField.text ?? ""
                default:
                return
            }
        }
        
        let paymentItem = ATHMPaymentItem(name: name, price: NSNumber(value: price), quantity: quantity)
        paymentItem.desc = desc
        paymentItem.metadata = metadata
        self.onCompleted?(paymentItem)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }

}
