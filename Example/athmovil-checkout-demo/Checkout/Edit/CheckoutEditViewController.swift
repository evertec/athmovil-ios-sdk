//
//  CheckoutEditViewController.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/5/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit
import athmovil_checkout

class CheckoutEditViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var cellRows: [[DefaultSectionCellType]] =  [[.publicToken,.timeOut,.paymentAmount,.theme],
                                                 [.subTotal,.tax,.metadata1,.metadata2]]
    
    var titleSection = ["CONFIGURATION","OPTIONAL PARAMETERS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        self.title = "Payment Configuration"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        let closeIcon = UIImage(named: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: closeIcon , style: .plain, target:
            self, action: #selector(closeIconPressed))
    }
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.sectionFooterHeight = UITableView.automaticDimension;
        tableView.estimatedSectionFooterHeight = 96;
        let checkoutEditFooterNibName = "CheckoutEditFooterTableViewCell"
        let checkoutEditFooterNib = UINib(
            nibName: checkoutEditFooterNibName, bundle: nil)
        tableView.register(checkoutEditFooterNib, forCellReuseIdentifier:
            CheckoutEditFooterTableViewCell.reuseIdentifier)
    }
    
    func setupLongPressGesture(subView: UIView) {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.5
        longPressGesture.delegate = self
        subView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func closeIconPressed(){
        UserPreferences.shared.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let subView = gestureRecognizer.view
            if subView is UITableViewCell {
                let cell = subView as! UITableViewCell
                if let text = cell.detailTextLabel?.text {
                    UIPasteboard.general.string = text
                }
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEvent.EventSubtype.motionShake) {
            alertPresetConfig()
        }
    }
    
    fileprivate func alertPresetConfig() {
        let alert = UIAlertController(title: "Payment Configuration", message: "Do you want to restore to preset configuration?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { [unowned self] _ in
            UserPreferences.reset()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.tableView.reloadData()
            }
        })
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CheckoutEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellRows[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellRows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "SettingsCell")
        cell.selectionStyle = .none
        cell.accessoryView?.tag = indexPath.row
        let row = cellRows[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = row.title
        switch row {
        case .publicToken:
            inputCell(cell, title: row.title, value: UserPreferences.shared.publicToken)
            setupLongPressGesture(subView: cell)
        case .timeOut:
            inputCell(cell, title: row.title, value: "\(UserPreferences.shared.timeOut) seconds")
        case .paymentAmount:
            inputCell(cell, title: row.title, value: "$\(UserPreferences.shared.paymentAmount)")
        case .theme:
            cell.accessoryView = nil
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = row.title
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.text = UserPreferences.shared.nameTheme

        // OPTIONAL PARAMETERS
        case .subTotal:
            inputCell(cell, title: row.title, value: "$\(UserPreferences.shared.subTotal)")
        case .tax:
            inputCell(cell, title: row.title, value: "$\(UserPreferences.shared.tax)")
        case .metadata1:
            inputCell(cell, title: row.title, value: UserPreferences.shared.metadata1)
        case .metadata2:
            inputCell(cell, title: row.title, value: UserPreferences.shared.metadata2)
        }
        
        return cell
    }
    
    func inputCell(_ cell: UITableViewCell, title: String?, value: String){
        cell.accessoryView = nil
        cell.textLabel?.text = title ?? ""
        cell.detailTextLabel?.text = value
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
    }
    
}

extension CheckoutEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let reuseIdentifier = CheckoutEditFooterTableViewCell.reuseIdentifier
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! CheckoutEditFooterTableViewCell
            return cell.contentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleSection[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = cellRows[indexPath.section][indexPath.row]
        
        if type == .theme{
            performSegue(withIdentifier: "changeColor", sender: nil)
            return
        }
        
        changeValue(cellType: type)
    }
    
    func changeValue(cellType: DefaultSectionCellType) {
        let alertController = UIAlertController(title: cellType.messageTitle, message: cellType.messageContent, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = cellType.title
            textField.keyboardType = cellType.keyBoard
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            if let text = textField.text {
                switch cellType{
                case .publicToken:
                    UserPreferences.shared.publicToken = text
                case .timeOut:
                    UserPreferences.shared.timeOut =  Double(text) ?? 0.0
                case .paymentAmount:
                    UserPreferences.shared.paymentAmount = Double(text) ?? 0
                case .subTotal:
                    UserPreferences.shared.subTotal = Double(text) ?? 0
                case .tax:
                    UserPreferences.shared.tax = Double(text) ?? 0
                case .metadata1:
                    UserPreferences.shared.metadata1 = text
                case .metadata2:
                    UserPreferences.shared.metadata2 = text
                default:
                    return
                }
                self.tableView.reloadData()
            }
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
