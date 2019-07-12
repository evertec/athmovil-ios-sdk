//
//  TransactionConfirmationViewController.swift
//  ATHMovil
//
//  Created by Leonardo Maldonado on 5/1/18.
//  Copyright © 2018 EVERTEC, Inc. All rights reserved.
//

import UIKit
import athm_checkout

protocol TransactionConfirmationOutputs {
    
    /// Emits when the the done button is pressed.
    var done: (() -> Void)! { set get }
}

protocol TransactionConfirmationViewModelType {
    var outputs: TransactionConfirmationOutputs { set get }
}

class TransactionConfirmationViewController: UIViewController,
TransactionConfirmationViewModelType, TransactionConfirmationOutputs {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [[String: String]] = []
    
    var items: [ATHMPaymentItem]?
    
    var done: (() -> Void)!
    
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
    }
    
    @IBAction func doneButtonPressed(){
        done()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ItemsResponseViewController {
            controller.items = items
        }
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
        cell.backgroundColor = .white
        let key = tableData[indexPath.row].keys.first
        let value = tableData[indexPath.row].values.first
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value
        if key == "items" {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}
