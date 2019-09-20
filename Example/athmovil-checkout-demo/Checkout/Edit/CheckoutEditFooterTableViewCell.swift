//
//  CheckoutEditFooterTableViewCell.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/5/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

class CheckoutEditFooterTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "CheckoutEditFooterTableViewCell"

    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDescLabelStyle()
    }
    
    fileprivate func setDescLabelStyle() {
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 0
        descLabel.textColor = .gray
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.text = "Payment will be sent to the account of the provided\n" +
        "Public Token for the provided Payment Amount."
    }
}
