//
//  CheckoutDefaultTableViewCell.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

protocol CheckoutDefaultCellDelegate: class {
    func didUpdateQuantity(at index: UITableViewCell, with value: String)
}

class CheckoutDefaultTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "CheckoutDefaultTableViewCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    weak var delegate: CheckoutDefaultCellDelegate?
    
    var transactionItem: TransactionItem! {
        didSet {
            productImageView.image = transactionItem?.image
            nameLabel.text = transactionItem?.name
            if let price = transactionItem?.price {
                priceLabel.text = "$\(price)"
            } else {
                priceLabel.text = "N/A"
            }
            descLabel.text = transactionItem?.desc
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImageView.layer.cornerRadius = 4
        productImageView.layer.masksToBounds = true
    }
    
    @IBAction func stepperViewValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        let stringValue = String(value)
        transactionItem?.quantity = stringValue
        delegate?.didUpdateQuantity(at:
            self, with: stringValue)
    }
}
