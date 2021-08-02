//
//  CheckoutDefaultTableViewCell.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit
import athmovil_checkout


class CheckoutDefaultTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "CheckoutDefaultTableViewCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var metadata: UILabel!
    
    var transactionItem: ATHMPaymentItem! {
        didSet {

            nameLabel.text = transactionItem.name
            priceLabel.text = "$\(transactionItem.price)"
            descLabel.text = transactionItem.desc
            quantity.text = "x \(transactionItem.quantity)"
            metadata.text = "\(transactionItem.metadata)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImageView.layer.cornerRadius = 4
        productImageView.layer.masksToBounds = true
    }
    
}
