//
//  ResponseViewController.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

enum ResponseType: Int {
    case businessUnavailable
    case userHaveNoActiveCards
    case timeout
    case canceled
    case success
    
    var txt: String {
        switch self {
        case .businessUnavailable:
            return "BusinessUnavailable"
        case .userHaveNoActiveCards:
            return "UserHaveNoActiveCards"
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
        var dictionary: [String: Any] = [:]
        let responseType = ResponseType(rawValue: sender.tag)
        switch responseType {
        case .businessUnavailable?:
            dictionary = [
                "completed": true,
                "status": ResponseType.businessUnavailable.txt,
                "cartReferenceId": "123456789"
            ]
        case .userHaveNoActiveCards?:
            dictionary = [
                "completed": false,
                "status": ResponseType.userHaveNoActiveCards.txt,
                "cartReferenceId": "123456789"
            ]
        case .timeout?:
            dictionary = [
                "completed": false,
                "status": ResponseType.timeout.txt,
                "cartReferenceId": "123456789"
            ]
        case .canceled?:
            dictionary = [
                "completed": false,
                "status": ResponseType.canceled.txt,
                "cartReferenceId": "123456789"
            ]
        case .success?:
            dictionary = [
                "completed": true,
                "status": ResponseType.success.txt,
                "cartReferenceId": "123456789",
                "dailyTransactionId": "111111111",
                "transactionReference": "0000000000"
            ]
        default:
            return
        }
        
        sendResponse(with: dictionary)
    }
    
    func sendResponse(with dictionary: [String: Any]) {
        
        guard let jsonString = dictionary.toJSONString?
            .addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed) else { return }
        
        guard let scheme = transaction.scheme else { return }
        
        guard let url = URL(string: "\(scheme)://?athm_payment_data="
            + "\(jsonString)") else { return }
        
        UIApplication.shared.open(url, options:
            [:], completionHandler: nil)
    }
}

