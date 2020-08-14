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
    fileprivate var userPref = UserPreferences.shared
    
    lazy var athButton: ATHMCheckoutButton = {
        return ATHMCheckout.shared.getCheckoutButton(withTarget: self, action: #selector(payWithATHMButtonPressed))
    }()

    @IBOutlet weak var checkoutButton: UIButton! {
        didSet {
            setCheckoutButtonStyle()
        }
    }

    var transaction: Transaction!
    var shipping = Shipping()
    var descTextCell = ["Contact", "Shipping", "Subtotal", "Tax", "Total"]

    /// This index is used to interpolate between the two different types
    /// of items when the user adds a new item pressing the add button in
    /// the navigation bar.
    var interpolationIndex: Int = 0

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        transaction = Transaction.dummyTransaction
        ATHMCheckout.shared.delegate = self
        
        setupTableView()
        setupNavigationBar()
        setupCheckoutButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let theme = athmovil_checkout.AMCheckoutButtonStyle(rawValue: UserPreferences.shared.theme) {
            athButton.style = theme
        }
    }

    // MARK: Helper Methods

    @objc func payWithATHMButtonPressed(_ sender: Any) {

        guard let payment = try? getPayment(with: transaction)
            else { return }
        
        ATHMCheckout.shared.publicToken = userPref.publicToken
        ATHMCheckout.shared.timeout = userPref.timeOut
        payment.total = NSNumber(value: userPref.paymentAmount)
        
        if !userPref.subTotalIsOn { payment.subtotal = nil }
        if !userPref.taxIsOn { payment.tax = nil }
        if !userPref.metadata1IsOn { payment.metadata1 = nil }
        if !userPref.metadata2IsOn { payment.metadata2 = nil }
        if !userPref.itemsIsOn { payment.items = nil }

        do {
            try ATHMCheckout.shared.checkout(with: payment)
        } catch let error {
            print(error)
        }
    }

    fileprivate func setupCheckoutButton() {

        buttonStack.insertArrangedSubview(athButton, at: 0)

        NSLayoutConstraint.activate([
            athButton.leftAnchor.constraint(equalTo:
                view.leftAnchor, constant: 16),
            athButton.rightAnchor.constraint(equalTo:
                view.rightAnchor, constant: -16),
            athButton.heightAnchor.constraint(
                equalToConstant: 48)
        ])
    }

    fileprivate func getPayment(with transaction: Transaction) throws -> ATHMPayment? {

        var items: [ATHMPaymentItem] = []
        var list = transaction.itemList
        if list.isEmpty { list = Transaction.dummyTransactionItemList }
        for item in list {
            let price = NSNumber(value: Double(item.price)!)
            let newElement = try ATHMPaymentItem(
                desc: item.desc,
                name: item.name,
                priceNumber: price,
                quantity: Int(item.quantity)!,
                metadata: item.metadata)
            items.append(newElement)
        }
        
        let totalNumber = NSNumber(value: Double(transaction.total)!)
        let subTotalNumber = NSNumber(value: Double(transaction.subTotal)!)
        let taxNumber = NSNumber(value: Double(transaction.tax)!)
        if let payment = try? ATHMPayment(
            total: totalNumber, subtotal: subTotalNumber, tax: taxNumber, metadata1: "metadata1", metadata2: "metadata2", items: items) {

            return payment
        }
        return nil
    }

    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        let shippingNibName = "ShippingTableViewCell"
        let checkoutSummaryNibName = "CheckoutSummaryTableViewCell"
        let shippingNib = UINib(
            nibName: shippingNibName, bundle: nil)
        let checkoutSummaryNib = UINib(
            nibName: checkoutSummaryNibName, bundle: nil)

        tableView.register(shippingNib, forCellReuseIdentifier:
            ShippingTableViewCell.reuseIdentifier)
        tableView.register(checkoutSummaryNib, forCellReuseIdentifier:
            CheckoutSummaryTableViewCell.reuseIdentifier)
    }

    fileprivate func setCheckoutButtonStyle() {
        checkoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        checkoutButton.setTitle("CHECKOUT", for: .normal)
        checkoutButton.tintColor = .white
        checkoutButton.backgroundColor = .black
        checkoutButton.roundedWithShadow()
    }

    fileprivate func setupNavigationBar() {
        title = "Cart"
        let chevronIcon = UIImage(named: "ic_chevron")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: chevronIcon , style: .plain, target:
            self, action: #selector(chevronIconPressed))
    }
    
    @objc func chevronIconPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.transaction
                .itemList.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at:
                .bottom, animated: true)
        }
    }

    fileprivate func presentTransactionResult(status: ATHMStatus, referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {

        let storyboard = UIStoryboard(name:
            "TransactionConfirmationViewController", bundle: nil)

        if let navController = storyboard
            .instantiateInitialViewController() as? UINavigationController {
            
            if let confirmationViewController = navController.topViewController as? TransactionConfirmationViewController {
                confirmationViewController.tableData.append(["status": status.rawValue])
                if let referenceNumber = referenceNumber {
                    confirmationViewController.tableData.append(["referenceNumber": referenceNumber])
                }
                
                confirmationViewController.tableData.append(["total": String(format: "$ %.2f", total.doubleValue)])
                
                if tax != nil {
                    confirmationViewController.tableData.append(["tax": String(format: "$ %.2f", tax!.doubleValue)])
                }
                if subtotal != nil {
                    confirmationViewController.tableData.append(["subtotal": String(format: "$ %.2f", subtotal!.doubleValue)])
                }
                if let metadata1 = metadata1 {
                    confirmationViewController.tableData.append(["metadata1": metadata1])
                }
                if let metadata2 = metadata2 {
                    confirmationViewController.tableData.append(["metadata2": metadata2])
                }
                if let items = items {
                    confirmationViewController.tableData.append(["items": ""])
                    confirmationViewController.items = items
                }
                
                confirmationViewController.outputs.done = { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            
            navigationController?.present(
                navController, animated: true, completion: nil)
        }
    }
}

// MARK: UITableViewDelegate

extension CheckoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 {
            return 90
        }
        return 67
    }

    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 {
            let reuseIdentifier = ShippingTableViewCell.reuseIdentifier
            let cell = tableView.dequeueReusableCell(
                withIdentifier: reuseIdentifier, for: indexPath)
                as! ShippingTableViewCell
            cell.configure(type: indexPath.row == 0 ? .contact : .shipping , shipping: shipping)
            return cell
        } else {
            let reuseIdentifier = "SimpleCell"
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: reuseIdentifier)
            cell.textLabel?.text = descTextCell[indexPath.row]
            cell.backgroundColor = .clear
            cell.backgroundView?.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            var descriptor = UIFontDescriptor(name: UIFont.systemFontSize.description, size: 18.0)
            descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.medium]])
            let font = UIFont(descriptor: descriptor, size: 18.0)
            cell.detailTextLabel?.font = font
            cell.detailTextLabel?.textColor = .black
            switch indexPath.row {
            case 2:
                cell.detailTextLabel?.text = "$\(transaction.subTotal)"
            case 3:
                cell.detailTextLabel?.text = "$\(transaction.tax)"
            case 4:
                cell.detailTextLabel?.text = String(format: "$ %.2f", UserPreferences.shared.paymentAmount)
            default:
                cell.detailTextLabel?.text = "-"
            }
            return cell
        }
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
    func onCompletedPayment(referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        presentTransactionResult(status: .success, referenceNumber: referenceNumber, total: total, tax: tax, subtotal: subtotal, metadata1: metadata1, metadata2: metadata2, items: items)
    }
    
    func onCancelledPayment(referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        presentTransactionResult(status: .canceled, referenceNumber: referenceNumber, total: total, tax: tax, subtotal: subtotal, metadata1: metadata1, metadata2: metadata2, items: items)
    }
    
    func onExpiredPayment(referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        presentTransactionResult(status: .timeout, referenceNumber: referenceNumber, total: total, tax: tax, subtotal: subtotal, metadata1: metadata1, metadata2: metadata2, items: items)
    }
}
