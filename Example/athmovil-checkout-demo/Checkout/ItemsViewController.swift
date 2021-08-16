//
//  ItemsViewController.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/10/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import UIKit
import athmovil_checkout

class ItemsViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton! {
        didSet {
            checkoutButton.roundedWithShadow()
        }
    }
    
    var itemsList = UserPreferences.shared.items
    
    var itemDefault: ATHMPaymentItem {
        let itemDefault = ATHMPaymentItem(name: "Item", price: 1, quantity: 1)
        itemDefault.desc = "Description"
        itemDefault.metadata = "Metadata"
        return itemDefault
    }
        
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        tableView.backgroundIfNeeded()
    }
        
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        
        let checkoutDefaultNibName = "CheckoutDefaultTableViewCell"
        let checkoutDefaultNib = UINib(nibName: checkoutDefaultNibName, bundle: nil)
        
        tableView.register(checkoutDefaultNib,
                           forCellReuseIdentifier: CheckoutDefaultTableViewCell.reuseIdentifier)
    }
    
    @IBAction func addItem(_ sender: Any) {
        addItem()
    }
}

// MARK: Items

extension ItemsViewController {
    
    private func addItem() {
        tableView.performBatchUpdates {
            itemsList.append(itemDefault)
            let indexPath = IndexPath(item: self.itemsList.count-1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .bottom)
            self.save(items: itemsList)
        } completion: { [unowned self] _ in
            self.tableView.backgroundIfNeeded()
        }
    }
    
    func showItem(at indexPath: IndexPath, tableView: UITableView) {
        
        let storyboard = UIStoryboard.init(name: "CheckoutViewController",
                                           bundle: .main)
        
        
        guard let navigation = storyboard.instantiateViewController(withIdentifier: "EditItemNavigationController") as? UINavigationController,
              let itemsViewController = navigation.viewControllers.first as? CheckoutAddItemViewController else {
            return
        }
        
        itemsViewController.item = itemsList[indexPath.row]
        
        itemsViewController.onCompleted = { item in
            navigation.dismiss(animated: true) {
                self.itemsList[indexPath.row] = item
                tableView.reloadRows(at: [indexPath], with: .fade)
                self.save(items: self.itemsList)
            }
        }
        
        navigation.modalPresentationStyle = .fullScreen
        navigationController?.present(navigation,
                                      animated: true,
                                      completion: {
                                        tableView.deselectRow(at: indexPath, animated: false)
                                      })
        
    }
    
    private func remove(_ indexPath: IndexPath, _ tableView: UITableView) {
        itemsList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        save(items: itemsList)
        
        OperationQueue.main.addOperation {
            self.tableView.backgroundIfNeeded()
        }
    }
    
    private func save(items: [ATHMPaymentItem]) {
        UserPreferences.shared.items = items
        UserPreferences.shared.save()
    }
}

// MARK: UITableViewDelegate

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showItem(at: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            remove(indexPath, tableView)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         .delete
    }
}

// MARK: UITableViewDataSource

extension ItemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = CheckoutDefaultTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! CheckoutDefaultTableViewCell
        
        let item = itemsList[indexPath.row]
        cell.transactionItem = item
        
        return cell
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


extension UITableView {
    
    var isEmpty: Bool { numberOfSections <= 0 || numberOfRows(inSection: 0) <= 0 }
    
    func backgroundIfNeeded() {
        
        switch isEmpty {
            case true:
                addBackGround()
            default:
                removeBackGround()
        }
    }
    
    private func addBackGround() {
    
        backgroundView = UIView(frame: frame)
        let label = UILabel(frame: frame)
        label.text = "There are not items"
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        backgroundView?.addSubview(label)
    }
    
    private func removeBackGround() {
        let view = backgroundView
        
        UIView.animate(withDuration: 0.2) {
            view?.alpha = 0
        } completion: { _ in
            self.backgroundView = nil
        }
    }
}
