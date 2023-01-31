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
    case enviroment
    case newFlow
    // Second section
    case subTotal
    case tax
    case metadata1
    case metadata2
    case phoneNumber
}

extension DefaultSectionCellType {
    
    var title: String {
        switch self {
        case .publicToken:
            return "Public token"
        case .theme:
            return "Theme"
        case .enviroment:
            return "Enviroment"
        case .newFlow:
            return "New Flow"
        case .tax:
            return "Tax"
        case .subTotal:
            return "Subtotal"
        case .timeOut:
            return "Timeout"
        case .paymentAmount:
            return "Payment Amount"
        case .metadata1:
            return "Metadata1"
        case .metadata2:
            return "Metadata2"
        case .phoneNumber:
            return "Phone Number"
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
        case .subTotal:
            return "Change Payment SubTotal"
        case .tax:
            return "Change Payment Tax"
        case .metadata1:
            return "Change Payment Metdata1"
        case .metadata2:
            return "Change Payment Metdata2"
        case .phoneNumber:
            return "Phone Number"
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
        case .subTotal:
            return "Provide the subtotal to process the payment for."
        case .tax:
            return "Provide the tax to process the payment for."
        case .metadata1:
            return "Provide the metadata1 to process the payment for."
        case .metadata2:
            return "Provide the metadata2 to process the payment for."
        case .phoneNumber:
            return "Provide the phoneNumbwe to process the payment for."
        default:
            return ""
        }
    }

    var keyBoard: UIKeyboardType {
        switch self {
        case .timeOut:
            return .numberPad
        case .paymentAmount, .tax, .subTotal:
            return .numbersAndPunctuation
        default:
            return .default
        }
    }
}
