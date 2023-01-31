//
//  CheckoutViewController.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/3/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit
import athmovil_checkout
import SwiftSpinner

class CheckoutViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonStack: UIStackView!
    fileprivate var userPref = UserPreferences.shared
    
    @IBOutlet weak var athmPaymentButton: ATHMButton!
        
    let sections = [["Token", "TimeOut", "Enviroment"],
                   ["Subtotal", "Tax", "Total", "Metadata1", "Metadata2", "items","Phone Number"]]


    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ATHMPaymentSession.shared.enviroment = userPref.enviroment
        switch UserPreferences.shared.theme {
            case 1:
                athmPaymentButton.theme = ATHMThemeLight()
            case 2:
                athmPaymentButton.theme = ATHMThemeNight()
            default:
                athmPaymentButton.theme = ATHMThemeClassic()
        }
    }
    
    // MARK: Helper Methods

    @IBAction func payWithATHMovil(_ sender: Any) {
        /// Payment object
        let payment = ATHMPayment(total: NSNumber(value: userPref.paymentAmount))
        payment.subtotal = NSNumber(value: userPref.subTotal)
        payment.tax = NSNumber(value: userPref.tax)
        payment.metadata1 = userPref.metadata1
        payment.metadata2 = userPref.metadata2
        payment.items = userPref.items
        /// This must be your url scheme, this scheme is going to be the url that ATH Movil will call after the payment
        let scheme: ATHMURLScheme = "athm-checkout"
        
        /// Your business token
        let businessAccount = ATHMBusinessAccount(token: userPref.publicToken)
        
        //NEW FLOW SECURE
        if(userPref.newFlow == "SI"){
            payment.phoneNumber = userPref.phoneNumber
            let request = ATHMPaymentSecureRequest(account: businessAccount, scheme: scheme, payment:payment)
            request.timeout = userPref.timeOut
            let handler = ATHMPaymentHandler(onCompleted: { [weak self] (payment) in
                SwiftSpinner.hide()
                self?.presentTransactionResult(payment: payment)
            }, onExpired: { [weak self] (payment) in
                SwiftSpinner.hide()
                self?.presentTransactionResult(payment: payment)
            }, onCancelled: { [weak self] (payment) in
                SwiftSpinner.hide()
                self?.presentTransactionResult(payment: payment)
            }, onPending: { (payment) in
                SwiftSpinner.hide()
            }, onFailed: { (payment) in
                SwiftSpinner.hide()
                self.presentTransactionResult(payment: payment)
            }) { [weak self] (error: ATHMPaymentError) in
                SwiftSpinner.hide()
                self?.present(messageFailure: error.failureReason, messageTitle: error.errorDescription)
            }
            SwiftSpinner.show("Loading...")
            request.pay(handler: handler)
        }else{
            let request = ATHMPaymentRequest(account: businessAccount, scheme: scheme,payment: payment)
            request.timeout = userPref.timeOut
            
            let handler = ATHMPaymentHandler(onCompleted: { [weak self] (payment) in
                self?.presentTransactionResult(payment: payment)
            }, onExpired: { [weak self] (payment) in
                self?.presentTransactionResult(payment: payment)
            }, onCancelled: { [weak self] (payment) in
                self?.presentTransactionResult(payment: payment)
            }, onPending: { [weak self] (payment) in
                self?.presentTransactionResult(payment: payment)
            }, onFailed: { [weak self] (payment) in
                self?.presentTransactionResult(payment: payment)
            }) { [weak self] (error: ATHMPaymentError) in
                self?.present(messageFailure: error.failureReason, messageTitle: error.errorDescription)
            }
            request.pay(handler: handler)
        }
    }
    
    func setAdditional(_ cell: UITableViewCell, indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = userPref.publicToken
            case 1:
                cell.detailTextLabel?.text = "\(userPref.timeOut)"
            default:
                cell.detailTextLabel?.text = "\(userPref.enviroment)"
        }
    }
    
    func setPayment(_ cell: UITableViewCell, indexPath: IndexPath) {
        
        switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = "$\(userPref.subTotal)"
            case 1:
                cell.detailTextLabel?.text = "$\(userPref.tax)"
            case 2:
                cell.detailTextLabel?.text = String(format: "$ %.2f", userPref.paymentAmount)
            case 3:
                cell.detailTextLabel?.text = userPref.metadata1
            case 4:
                cell.detailTextLabel?.text = userPref.metadata2
            case 5:
                cell.detailTextLabel?.text = "Items \(userPref.items.count)"
            case 6:
                cell.detailTextLabel?.text = userPref.phoneNumber
            default:
                cell.detailTextLabel?.text = "-"
        }
        
    }

    func present(messageFailure: String, messageTitle: String){
        let alertController = UIAlertController(title: messageTitle,
                                                message: messageFailure,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }

    fileprivate func presentTransactionResult(payment: ATHMPaymentResponse) {
    
        let storyboard = UIStoryboard(name: "TransactionConfirmationViewController", bundle: nil)

        if let navController = storyboard.instantiateInitialViewController() as? UINavigationController {
            
            
            if let confirmationViewController = navController.topViewController as? TransactionConfirmationViewController {
                
                confirmationViewController.responsePayment = payment

                confirmationViewController.outputs.done = { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            
            navController.modalPresentationStyle = .fullScreen
            navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    
}

// MARK: UITableViewDelegate

extension CheckoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
}

// MARK: UITableViewDataSource

extension CheckoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "Additional Information"
            default:
                return "Payment Info"
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell.init(style: .value1,
                                                                                                 reuseIdentifier: "Cell")
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        cell.detailTextLabel?.numberOfLines = 2
        
        switch indexPath.section {
            case 0:
                setAdditional(cell, indexPath: indexPath)
            default:
                setPayment(cell, indexPath: indexPath)
        }
        
        return cell

    }

}

