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
    
    @IBOutlet weak var athmPaymentButton: ATHMButton!
    
    var itemsList = [ATHMPaymentItem]()
    
    @IBOutlet weak var checkoutButton: UIButton! {
        didSet {
            setCheckoutButtonStyle()
        }
    }

    var shipping = Shipping()
    var descTextCell = ["Contact", "Shipping", "Subtotal", "Tax", "Total", "Metadata1", "Metadata2", "items"]


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        ///This must be your url scheme, this scheme is going to be the url that ATH Movil will call after the payment
        let appClient = ATHMClientApp(urlScheme: "athm-checkout")
        
        ///Your business token
        let businessAccount = ATHMBusinessAccount(token: userPref.publicToken)
        
        ///Payment object
        let payment = ATHMPayment(total: NSNumber(value: userPref.paymentAmount))
        payment.subtotal = NSNumber(value: userPref.subTotal)
        payment.tax = NSNumber(value: userPref.tax)
        payment.metadata1 = userPref.metadata1
        payment.metadata2 = userPref.metadata2
        payment.items = itemsList
        
        let handler = ATHMPaymentHandler(onCompleted: { [weak self] (payment) in
            
            DispatchQueue.main.async {
                self?.presentTransactionResult(payment: payment)
            }
            
        }, onExpired: { [weak self] (payment) in
            
            DispatchQueue.main.async {
                self?.presentTransactionResult(payment: payment)
            }
        }, onCancelled: { [weak self] (payment) in
            
            DispatchQueue.main.async {
                self?.presentTransactionResult(payment: payment)
            }
            
        }) { [weak self] (error: ATHMPaymentError) in
            
            DispatchQueue.main.async {
                self?.presen(messageFailure: error.failureReason, messageTitle: error.errorDescription)
            }
        }
        
        ///Payment Manager
        let request = ATHMPaymentRequest(account: businessAccount, appClient: appClient, payment: payment)
        request.timeout = userPref.timeOut
        request.pay(handler: handler)
        
//        ///Payment Manager Simulated Payment
//        let request = ATHMPaymentRequestSimulated(account: businessAccount, appClient: appClient, payment: payment)
//        request.paySimulated(handler: handler)
        
    }


    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        let shippingNibName = "ShippingTableViewCell"
        let checkoutSummaryNibName = "CheckoutSummaryTableViewCell"
        
        let shippingNib = UINib(nibName: shippingNibName, bundle: nil)
        let checkoutSummaryNib = UINib( nibName: checkoutSummaryNibName, bundle: nil)

        tableView.register(shippingNib, forCellReuseIdentifier: ShippingTableViewCell.reuseIdentifier)
        tableView.register(checkoutSummaryNib, forCellReuseIdentifier: CheckoutSummaryTableViewCell.reuseIdentifier)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: chevronIcon ,
                                                           style: .plain,
                                                           target:self,
                                                           action: #selector(chevronIconPressed))
    }
    
    @objc func chevronIconPressed() {
        self.navigationController?.popViewController(animated: true)
    }


    func presen(messageFailure: String, messageTitle: String){
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descTextCell.count
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
            cell.selectionStyle = .none
            var descriptor = UIFontDescriptor(name: UIFont.systemFontSize.description, size: 18.0)
            descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.medium]])
            let font = UIFont(descriptor: descriptor, size: 18.0)
            cell.detailTextLabel?.font = font
            cell.detailTextLabel?.textColor = .black
            switch indexPath.row {
            case 2:
                cell.detailTextLabel?.text = "$\(UserPreferences.shared.subTotal)"
            case 3:
                cell.detailTextLabel?.text = "$\(UserPreferences.shared.tax)"
            case 4:
                cell.detailTextLabel?.text = String(format: "$ %.2f", UserPreferences.shared.paymentAmount)
            case 5:
                cell.detailTextLabel?.text = UserPreferences.shared.metadata1
            case 6:
                cell.detailTextLabel?.text = UserPreferences.shared.metadata2
            case 7:
                cell.detailTextLabel?.text = "Items \(self.itemsList.count)"
            default:
                cell.detailTextLabel?.text = "-"
            }
            return cell
        }
        
        
       
    }
    
}

