//
//  ItemsViewController.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/10/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import UIKit
import athm_checkout

class ItemsViewController: UIViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton! {
        didSet {
            setCheckoutButtonStyle()
        }
    }
    
    var transaction: Transaction!
    
    /// This index is used to interpolate between the two different types
    /// of items when the user adds a new item pressing the add button in
    /// the navigation bar.
    var interpolationIndex: Int = 0
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transaction = Transaction.dummyTransaction
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
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
        checkoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        checkoutButton.setTitle("GO TO CART", for: .normal)
        checkoutButton.tintColor = .white
        checkoutButton.backgroundColor = .black
        checkoutButton.roundedWithShadow()
    }
    
    fileprivate func setupNavigationBar() {
        title = "Items"
        
        let chevronIcon = UIImage(named: "settings")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: chevronIcon , style: .plain, target:
            self, action: #selector(settingsIconPressed))
        
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc fileprivate func settingsIconPressed() {
        let storyboard = UIStoryboard.init(
            name: "CheckoutEditViewController", bundle: nil)
        
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController,
            let _ = navController.visibleViewController
                as? CheckoutEditViewController else { return }
        
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
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
        
        navigationController?.pushViewController(
            editViewController, animated: true)
    }
    
}

// MARK: UITableViewDelegate

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            transaction.itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath:
        IndexPath) -> UITableViewCell.EditingStyle {
        return transaction.itemList.count == 1 ? .none : .delete
    }
}

// MARK: UITableViewDataSource

extension ItemsViewController: UITableViewDataSource {
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

// MARK: CheckoutDefaultCellDelegate

extension ItemsViewController: CheckoutDefaultCellDelegate {
    func didUpdateQuantity(at cell: UITableViewCell, with value: String) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        transaction.itemList[indexPath.row].quantity = value
    }
}

// MARK: UIColor+DefaultColor

extension UIButton {
    func roundedWithShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
}
