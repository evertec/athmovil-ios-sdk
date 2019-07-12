//
//  CheckoutEditCell.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/12/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import UIKit

enum DefaultSectionCellType: Int {
    case publicToken
    case timeOut
    case paymentAmount
    case theme
    // Second section
    case subTotal
    case tax
    case metadata1
    case metadata2
    case items
}

extension DefaultSectionCellType {
    
    var title: String {
        switch self {
        case .publicToken:
            return "Public token"
        case .theme:
            return "Theme"
        case .tax:
            return "Tax"
        case .subTotal:
            return "Subtotal"
        case .items:
            return "Items"
        case .timeOut:
            return "Timeout"
        case .paymentAmount:
            return "Payment Amount"
        case .metadata1:
            return "Metadata1"
        case .metadata2:
            return "Metadata2"
        }
    }
    
    var messageTitle: String {
        switch self {
        case .publicToken:
            return "Change Public Token"
        case .timeOut:
            return "Change Timeout"
        case .paymentAmount:
            return "Change Payment Amount"
        default:
            return ""
        }
    }
    
    
    var messageContent: String {
        switch self {
        case .publicToken:
            return "Provide the token of the account that will receive the payment."
        case .timeOut:
            return "Provide a timeout value for the payment process in seconds."
        case .paymentAmount:
            return "Provide the amount to process the payment for."
        default:
            return ""
        }
    }
    
    var messageContentError: String {
        switch self {
        case .timeOut:
            return "The value must be between 60 and 600 seconds."
        default:
            return ""
        }
    }
    
    var keyBoard: UIKeyboardType {
        switch self {
        case .timeOut:
            return UIKeyboardType.numberPad
        case .paymentAmount:
            return UIKeyboardType.decimalPad
        default:
            return UIKeyboardType.default
        }
    }
}
