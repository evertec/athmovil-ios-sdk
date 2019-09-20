//
//  ResponseViewController.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

enum ResponseType: Int {
    case timeout
    case canceled
    case success
    
    var txt: String {
        switch self {
        case .timeout:
            return "TimeOut"
        case .canceled:
            return "Canceled"
        case .success:
            return "Success"
        }
    }
}

class ResponseViewController: UIViewController {
    
    var transaction: Transaction!
    
    @IBAction func responsePressed(_ sender: UIButton) {
        var dictionary: [String: Any?] = [:]
        let responseType = ResponseType(rawValue: sender.tag)
        switch responseType {
        case .timeout?:
            dictionary = [
                "completed": false,
                "status": ResponseType.timeout.txt,
                "referenceNumber": "1000000001",
                "total": transaction.total,
                "subtotal": transaction.subtotal ?? nil,
                "tax": transaction.tax ?? nil,
                "metadata1": transaction.metadata1 ?? nil,
                "metadata2": transaction.metadata2 ?? nil,
                "items": transaction.items?.map({ $0.toDictionary }) ?? nil
            ]
        case .canceled?:
            dictionary = [
                "completed": false,
                "status": ResponseType.canceled.txt,
                "referenceNumber": "1000000001",
                "total": transaction.total,
                "subtotal": transaction.subtotal ?? nil,
                "tax": transaction.tax ?? nil,
                "metadata1": transaction.metadata1 ?? nil,
                "metadata2": transaction.metadata2 ?? nil,
                "items": transaction.items?.map({ $0.toDictionary }) ?? nil
            ]
        case .success?:
            dictionary = [
                "completed": true,
                "status": ResponseType.success.txt,
                "referenceNumber": "1000000001",
                "total": transaction.total,
                "subtotal": transaction.subtotal ?? nil,
                "tax": transaction.tax ?? nil,
                "metadata1": transaction.metadata1 ?? nil,
                "metadata2": transaction.metadata2 ?? nil,
                "items": transaction.items?.map({ $0.toDictionary }) ?? nil
            ]
        default:
            return
        }
        
        sendResponse(with: dictionary)
    }
    
    func sendResponse(with dictionary: [String: Any?]) {
        
        guard let jsonString = dictionary.toJSONString?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) else { return }
        
        guard let scheme = transaction.scheme else { return }
        
        guard let url = URL(string: "\(scheme)://?athm_payment_data=\(jsonString)") else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

