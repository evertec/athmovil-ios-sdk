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
    @IBOutlet weak var stepperValueLabel: UILabel!
    @IBOutlet weak var stepperView: UIStepper!
    
    weak var delegate: CheckoutDefaultCellDelegate?
    
    var transactionItem: TransactionItem! {
        didSet {
            productImageView.image = transactionItem?.image
            nameLabel.text = transactionItem?.name
            priceLabel.text = transactionItem?.price
            stepperValueLabel.text = transactionItem?.quantity
            descLabel.text = transactionItem?.desc
            
            /// set stepper value equals to quantity
            guard let value = Double(
                transactionItem.quantity) else { return }
            stepperView.value = value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImageView.layer.cornerRadius = 4
        productImageView.layer.masksToBounds = true
        stepperView.tintColor = .default
    }
    
    @IBAction func stepperViewValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        let stringValue = String(value)
        transactionItem?.quantity = stringValue
        stepperValueLabel.text = stringValue
        delegate?.didUpdateQuantity(at:
            self, with: stringValue)
    }
}
