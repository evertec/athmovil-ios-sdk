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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton! {
        didSet {
            setCheckoutButtonStyle()
        }
    }
    
    var itemsList = [ATHMPaymentItem]()
    
    /// This index is used to interpolate between the two different types
    /// of items when the user adds a new item pressing the add button in
    /// the navigation bar.
    var interpolationIndex: Int = 0
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        
        setBackGround()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: chevronIcon ,
                                                            style: .plain,
                                                            target:self,
                                                            action: #selector(settingsIconPressed))
        
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc fileprivate func settingsIconPressed() {
        let storyboard = UIStoryboard.init(name: "CheckoutEditViewController", bundle: nil)
        
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController,
            let _ = navController.visibleViewController
                as? CheckoutEditViewController else { return }
        
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    
    @objc fileprivate func editIconPressed() {
        let storyboard = UIStoryboard.init(name: "CheckoutEditViewController", bundle: nil)
        
        guard let editViewController = storyboard.instantiateInitialViewController() as? CheckoutEditViewController else
        {
            return
        }
        
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAddItem", let navController = segue.destination as? UINavigationController,
           let itemController = navController.viewControllers.first as? CheckoutAddItemViewController {
            
            itemController.onCompleted = { [unowned self]  item in
                self.itemsList.append(item)
                
                self.dismiss(animated: true) {
                    self.tableView.performBatchUpdates({
                        let indexPath = IndexPath(item: self.itemsList.count-1, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .top)
                    }) { [unowned self] _ in
                        self.removeBackGround()
                    }
                    
                }
            }
        }
        
        if let checkoutViewController = segue.destination as? CheckoutViewController{
            checkoutViewController.itemsList = self.itemsList
        }
    }
    
    func setBackGround(){
        
        if self.itemsList.isEmpty{
            self.tableView.backgroundView = UIView(frame: self.tableView.frame)
            let label = UILabel(frame: self.tableView.frame)
            label.text = "There are not items"
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            self.tableView.backgroundView?.addSubview(label)
        }
    }
    
    func removeBackGround(){
        
        if !self.itemsList.isEmpty{
            let view = self.tableView.backgroundView
             
            UIView.animate(withDuration: 0.2, animations: {
                view?.alpha = 0
            }) { _ in
                self.tableView.backgroundView = nil
            }

        }
    }
    
}

// MARK: UITableViewDelegate

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.itemsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            OperationQueue.main.addOperation {
                self.setBackGround()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath:
        IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: UITableViewDataSource

extension ItemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = CheckoutDefaultTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CheckoutDefaultTableViewCell
        
        let item = self.itemsList[indexPath.row]
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
