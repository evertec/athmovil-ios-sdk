//
//  ShippingTableViewCell.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/10/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import UIKit

class ShippingTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "ShippingTableViewCell"
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var value1Label: UILabel!
    @IBOutlet weak var value2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(type: ShippingCellInfo, shipping: Shipping){
        switch type {
        case .contact:
            value1Label.text = shipping.contactName
            value2Label.text = shipping.contactEmail
        case .shipping:
            value1Label.text = shipping.address1
            value2Label.text = shipping.address2
        }
        descLabel.text = type.text
    }
}

struct Shipping {
    var contactName: String = "Daniel Martinez"
    var contactEmail: String = "daniel.martinez@email.com"
    var address1: String = "Cond. Vivienda Apt 123"
    var address2: String = "San Juan, PR 00926"
    init(){
    }
}
enum ShippingCellInfo {
    case contact
    case shipping
    
    var text: String {
        switch self {
        case .contact:
            return "Contact"
        case .shipping:
            return "Shipping"
        }
    }
}
