//
//  TransactionConfirmationViewController.swift
//  ATHMovil
//
//  Created by Leonardo Maldonado on 5/1/18.
//  Copyright © 2018 EVERTEC, Inc. All rights reserved.
//

import UIKit
import athmovil_checkout

protocol TransactionConfirmationOutputs {
    
    /// Emits when the the done button is pressed.
    var done: (() -> Void)? { set get }
}

protocol TransactionConfirmationViewModelType {
    var outputs: TransactionConfirmationOutputs { set get }
}

class TransactionConfirmationViewController: UIViewController,
TransactionConfirmationViewModelType, TransactionConfirmationOutputs {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [[String: String]] = []
    
    var responsePayment: ATHMPaymentResponse?
    
    var done: (() -> Void)?
    
    var outputs: TransactionConfirmationOutputs {
        set { /* Required **/ } get { return self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment Response"
        doneButton.setTitle("CLOSE", for: .normal)
        self.navigationController?.navigationBar.barTintColor = .white
        self.tableView.tableFooterView = UIView()
        doneButton.roundedWithShadow()
        
        if let responsePayment = responsePayment{
            tableData.append(contentsOf: build(responsePayment))
            tableData.append(["items": "total \(responsePayment.payment.items.count)"])
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndex = self.tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: selectedIndex, animated: false)
        }
    }
    
    @IBAction func doneButtonPressed(){
        done?()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ItemsResponseViewController {
            controller.items = self.responsePayment?.payment.items ?? [ATHMPaymentItem]()
        }
    }
    
    /**
     Creates the dicctionary to show in the result table view
     - Parameters:
         - payment: information of the payment
         - status: Current status of the payment
     */
    fileprivate func build(_ payment: ATHMPaymentResponse) -> [[String: String]]{
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        
        let dateTrasaction = formatDate.string(from: payment.status.date)
        
        let response: [[String: String]] =
                        [["status": payment.status.statusPayment],
                        ["date": dateTrasaction],
                        ["referenceNumber": payment.status.referenceNumber],
                        ["dailyTransactionID": "\(payment.status.dailyTransactionID)"],
                        ["name": payment.customer.name],
                        ["phoneNumber": "\(payment.customer.phoneNumber)"],
                        ["email": payment.customer.email],
                        ["total": String(format: "$ %.2f", payment.payment.total.doubleValue)],
                        ["tax": String(format: "$ %.2f", payment.payment.tax.doubleValue)],
                        ["subtotal": String(format: "$ %.2f", payment.payment.subtotal.doubleValue)],
                        ["fee": String(format: "$ %.2f", payment.payment.fee.doubleValue)],
                        ["netAmount": String(format: "$ %.2f", payment.payment.netAmount.doubleValue)],
                        ["metadata1": payment.payment.metadata1],
                        ["metadata2": payment.payment.metadata2]]
        
        return response
    }
}

extension TransactionConfirmationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), cell.accessoryType == .disclosureIndicator {
            performSegue(withIdentifier: "Items", sender: nil)
        }
    }
}

extension TransactionConfirmationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = .white
        let key = tableData[indexPath.row].keys.first
        let value = tableData[indexPath.row].values.first
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value
        
        if key == "items", let totalItems = responsePayment?.payment.items.count, totalItems > 0  {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}
