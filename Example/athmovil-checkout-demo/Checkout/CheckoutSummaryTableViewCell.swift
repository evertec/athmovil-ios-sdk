//
//  CheckoutSummaryTableViewCell.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

class CheckoutSummaryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "CheckoutSummaryTableViewCell"

    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subTotalValueLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .white
        totalLabel.textColor = .black
        totalValueLabel.textColor = .black
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        totalValueLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
}
