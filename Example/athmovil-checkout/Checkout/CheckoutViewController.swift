//
//  CheckoutViewController.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/3/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit
import athmovil_checkout

class CheckoutViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var checkoutButton: UIButton! {
        didSet {
            setCheckoutButtonStyle()
        }
    }
    
    var transaction: Transaction!
    
    /// This tuple is used to store the user preferences in the edit
    /// view controller.
    var userPref: (Bool, Bool, Bool)?
    
    /// This index is used to interpolate between the two different types
    /// of items when the user adds a new item pressing the add button in
    /// the navigation bar.
    var interpolationIndex: Int = 0

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transaction = Transaction.dummyTransaction
        AMCheckout.shared.delegate = self
        AMCheckout.shared.timeout = 60
        
        setupTableView()
        setupNavigationBar()
        setupCheckoutButton()
    }
    
    // MARK: Helper Methods
    
    @objc func payWithATHMButtonPressed(_ sender: Any) {
        
        guard var payment = getPayment(with: transaction)
            else { return }
        
        payment = validateUserPref(with: payment)
        
        do {
            try AMCheckout.shared.checkout(with: payment)
        } catch let error {
            print(error)
        }
    }
    
    fileprivate func setupCheckoutButton() {
        
        let checkoutButton = AMCheckout.shared.getCheckoutButton(
            withTarget: self, action: #selector(payWithATHMButtonPressed))
        
        buttonStack.insertArrangedSubview(checkoutButton, at: 0)
        
        NSLayoutConstraint.activate([
            checkoutButton.leftAnchor.constraint(equalTo:
                view.leftAnchor, constant: 16),
            checkoutButton.rightAnchor.constraint(equalTo:
                view.rightAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(
                equalToConstant: 48)
        ])
    }
    
    fileprivate func validateUserPref(with payment: AMPayment) -> AMPayment {
        
        guard let (taxIsOn, subTotalIsOn, itemsIsOn)
            = userPref else { return payment }
        
        if !taxIsOn {
            payment.tax = nil
        }
        
        if !subTotalIsOn {
             payment.subTotal = nil
        }

        if !itemsIsOn {
             payment.items = nil
        }
        
        return payment
    }
    
    fileprivate func getPayment(with transaction: Transaction) -> AMPayment? {
        
        var items: [AMPaymentItem] = []
        
        for item in transaction.itemList {
            
            let newElement = AMPaymentItem(
                desc: item.desc,
                name: item.name,
                price: item.price,
                quantity: item.quantity)
            
            items.append(newElement)
        }
        
        let payment = AMPayment(
            referenceId: transaction.cartReferenceId,
            subTotal: transaction.subTotal,
            tax: transaction.tax,
            total: transaction.total,
            items: items)
        
        return payment
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionFooterHeight = 120;
        
        let checkoutDefaultNibName = "CheckoutDefaultTableViewCell"
        let checkoutSummaryNibName = "CheckoutSummaryTableViewCell"
        let checkoutDefaultNib = UINib(
            nibName: checkoutDefaultNibName, bundle: nil)
        let checkoutSummaryNib = UINib(
            nibName: checkoutSummaryNibName, bundle: nil)
        
        tableView.register(checkoutDefaultNib, forCellReuseIdentifier:
            CheckoutDefaultTableViewCell.reuseIdentifier)
        tableView.register(checkoutSummaryNib, forCellReuseIdentifier:
            CheckoutSummaryTableViewCell.reuseIdentifier)
    }
    
    fileprivate func setCheckoutButtonStyle() {
        checkoutButton.titleLabel?.font
            = UIFont.boldSystemFont(ofSize: 18)
        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.tintColor = .white
        checkoutButton.backgroundColor = .default
        checkoutButton.layer.shadowColor = UIColor(
            red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        checkoutButton.layer.shadowOffset = CGSize(
            width: 0.0, height: 2.0)
        checkoutButton.layer.shadowOpacity = 1.0
        checkoutButton.layer.shadowRadius = 2.0
        checkoutButton.layer.masksToBounds = false
        checkoutButton.layer.cornerRadius = 4.0
    }
    
    fileprivate func setupNavigationBar() {
        title = "Cart"
        
        let chevronIcon = UIImage(named: "ic_chevron")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: chevronIcon , style: .plain, target:
            self, action: #selector(chevronIconPressed))

        let editButtonItem = UIBarButtonItem(barButtonSystemItem:
            .edit, target: self, action: #selector(editIconPressed))

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target:
            self, action: #selector(addIconPressed))

        navigationItem.setRightBarButtonItems(
            [addButtonItem, editButtonItem], animated: true)
    }
    
    @objc fileprivate func chevronIconPressed() { /* Not applies **/ }
    
    @objc fileprivate func addIconPressed() {
        let newTransactionItem = Transaction
            .dummyTransactionItemList[interpolationIndex]
        interpolationIndex = interpolationIndex == 0 ? 1 : 0
        transaction.itemList.append(newTransactionItem)
        
        let newRowIndex = transaction.itemList.count - 1
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        scrollToBottom()
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.transaction
                .itemList.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at:
                .bottom, animated: true)
        }
    }
    
    @objc fileprivate func editIconPressed() {
        let storyboard = UIStoryboard.init(
            name: "CheckoutEditViewController", bundle: nil)
        
        guard let editViewController = storyboard
            .instantiateInitialViewController()
            as? CheckoutEditViewController else { return }
        
        editViewController.delegate = self
        
        if let userPref = userPref {
            editViewController.userPref = userPref
        }
        
        navigationController?.pushViewController(
            editViewController, animated: true)
    }
    
    fileprivate func presentTransactionConfirmation(with
        title: String, and description: String) {
        presentTransactionResult(isSucess: true, with: title, and: description)
    }
    
    fileprivate func presentTransactionFailed(with
        title: String, and description: String) {
        presentTransactionResult(isSucess: false, with: title, and: description)
    }
    
    fileprivate func presentTransactionResult(isSucess: Bool, with
        title: String, and description: String) {
        
        let storyboard = UIStoryboard.init(name:
            "TransactionConfirmationViewController", bundle: nil)
        
        let confirmationViewController = storyboard
            .instantiateInitialViewController()
            as! TransactionConfirmationViewController
        
        if !isSucess {
            confirmationViewController.backgroundColor =
                UIColor(red: 251/255, green: 75/255, blue: 79/255, alpha: 1.0)
            confirmationViewController.iconImage = UIImage(named:"ic_failed_red")
        }else {
            confirmationViewController.iconImage = UIImage(named:"ic_confirmed_blue")
        }
        
        confirmationViewController.primaryTitle = title
        confirmationViewController.secondaryTitle = description
        
        confirmationViewController.outputs.done = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        navigationController?.present(
            confirmationViewController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate

extension CheckoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section:
        Int) -> UIView? {
        
        let reuseIdentifier = CheckoutSummaryTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier)
            as! CheckoutSummaryTableViewCell
        cell.transaction = transaction
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            transaction.itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath:
        IndexPath) -> UITableViewCellEditingStyle {
        return transaction.itemList.count == 1 ? .none : .delete
    }
}

// MARK: UITableViewDataSource

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return transaction.itemList.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = CheckoutDefaultTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier, for: indexPath)
            as! CheckoutDefaultTableViewCell
        cell.delegate = self
        cell.transactionItem = transaction.itemList[indexPath.row]
        
        return cell
    }
}

// MARK: CheckoutEditDelegate

extension CheckoutViewController: CheckoutEditDelegate {
    func didUpdatePreferences(_ pref: (Bool, Bool, Bool)) {
        self.userPref = pref
    }
}

// MARK: CheckoutDefaultCellDelegate

extension CheckoutViewController: CheckoutDefaultCellDelegate {
    func didUpdateQuantity(at cell: UITableViewCell, with value: String) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        transaction.itemList[indexPath.row].quantity = value
    }
}

// MARK: AMCheckoutDelegate

extension CheckoutViewController: AMCheckoutDelegate {
    func paymentFailed(with referenceId: String, errorCode: String) {
        var errorDescription: String
        switch errorCode {
        case "UserHaveNoActiveCards":
            errorDescription = "The user does not have any valid cards in his ATHM Account."
        case "BusinessUnavailable":
            errorDescription = "This business can't receive payments at the moment. Please try again later."
        case "TimeOut":
            errorDescription = "The transaction 'expireIn' time has been reached."
        default:
            errorDescription = "Unexpected error"
        }
        
        presentTransactionFailed(with: errorCode, and: errorDescription)
    }
    
    func paymentCanceled(with referenceId: String) {
        let title = "Payment Canceled"
        let message = "Your payment has been canceled."
        presentTransactionFailed(with: title, and: message)
    }
    
    func paymentSuccess(with referenceId: String,
                        transactionReference: String,
                        dailyTransactionId: String) {
        let title = "We've send you a confirmation email."
        var message = "Your order has been processed "
        message += "transaction reference:\(transactionReference) "
        message += "reference id:\(referenceId) "
        message += "dailyId: \(dailyTransactionId)"
        presentTransactionConfirmation(with: title, and: message)
    }
}

// MARK: UIColor+DefaultColor

extension UIColor {
    static let `default` = UIButton(type: UIButtonType.system)
        .titleColor(for: .normal)!
}

