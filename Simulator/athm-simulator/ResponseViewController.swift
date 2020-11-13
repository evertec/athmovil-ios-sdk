//
//  ResponseViewController.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

enum ResponseType: String {
    case expired = "expired"
    case cancelled = "cancelled"
    case completed = "completed"
}

class ResponseViewController: UIViewController {
    
    var request: TransactionRequest!
    
    @IBAction func responseCompletedPressed(_ sender: UIButton) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        
    
        let response = TransactionResponse(status: "completed",
                                          date: dateFormatter.string(from: Date()),
                                          referenceNumber: "1000000001",
                                          dailyTransactionID: 1,
                                          subtotal: request.subtotal,
                                          tax: request.tax,
                                          total: request.total,
                                          fee: 1,
                                          netAmount: 1,
                                          name: "Completed Test",
                                          email: "testCompleted@email.com",
                                          phoneNumber: "(787) 111-1111",
                                          metadata1: request.metadata1,
                                          metadata2: request.metadata2,
                                          items: request.items,
                                          version: "3.0")
        
        sendResponse(with: response)
    }
    
    @IBAction func responseExpiredPressed(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        
    
        let response = TransactionResponse(status: "expired",
                                           date: dateFormatter.string(from: Date()),
                                           referenceNumber: "",
                                           dailyTransactionID: 0,
                                           subtotal: request.subtotal,
                                           tax: request.tax,
                                           total: request.total,
                                           fee: 0,
                                           netAmount: 0,
                                           name: "Expired Test",
                                           email: "testExpired@email.com",
                                           phoneNumber: "(787) 222-2222",
                                           metadata1: request.metadata1,
                                           metadata2: request.metadata2,
                                           items: request.items,
                                           version: "3.0")
        
        sendResponse(with: response)
    }
    
    @IBAction func responseCancelledPressed(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        
        let response = TransactionResponse(status: "cancelled",
                                           date: dateFormatter.string(from: Date()),
                                           referenceNumber: "",
                                           dailyTransactionID: 0,
                                           subtotal: request.subtotal,
                                           tax: request.tax,
                                           total: request.total,
                                           fee: 0,
                                           netAmount: 0,
                                           name: "Cancelled Test",
                                           email: "testCancelled@email.com",
                                           phoneNumber: "(787) 333-3333",
                                           metadata1: request.metadata1,
                                           metadata2: request.metadata2,
                                           items: request.items,
                                           version: "3.0")
        
        sendResponse(with: response)
    }
    
    func sendResponse(with response: TransactionResponse) {
        
        do {
            let decoder = JSONEncoder()
            let dataResponse = try decoder.encode(response)
            let stringData = String(data: dataResponse, encoding: String.Encoding.utf8)
            
            guard let jsonString = stringData?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) else {
                return
            }
            
            guard let url = URL(string: "\(request.scheme)://?athm_payment_data=\(jsonString)") else {
                return
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } catch {
            debugPrint("Error sending response to dummy")
        }
    }
}

