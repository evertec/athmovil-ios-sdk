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
                                                 [.subTotal,.tax,.metadata1,.metadata2,.items]]
    
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
    
    @objc fileprivate func accesoryViewChanged(_ sender: UISwitch) {
        guard let cellType = DefaultSectionCellType(rawValue: sender.tag) else {
            return
        }
        switch cellType {
        case .subTotal:
            UserPreferences.shared.subTotalIsOn = sender.isOn
        case .tax:
            UserPreferences.shared.taxIsOn = sender.isOn
        case .metadata1:
            UserPreferences.shared.metadata1IsOn = sender.isOn
        case .metadata2:
            UserPreferences.shared.metadata2IsOn = sender.isOn
        case .items:
            UserPreferences.shared.itemsIsOn = sender.isOn
        default:
            return
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
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(accesoryViewChanged(_:)), for: .valueChanged)
        switchView.tintColor = .black
        switchView.onTintColor = .black
        cell.accessoryView = switchView
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
            if let theme = athmovil_checkout.AMCheckoutButtonStyle(rawValue: UserPreferences.shared.theme) {
                cell.detailTextLabel?.text = theme.name
            }
        // OPTIONAL PARAMETERS
        case .subTotal:
            switchView.isOn = UserPreferences.shared.subTotalIsOn
            switchView.tag = row.rawValue
        case .tax:
            switchView.isOn = UserPreferences.shared.taxIsOn
            switchView.tag = row.rawValue
        case .metadata1:
            switchView.isOn = UserPreferences.shared.metadata1IsOn
            switchView.tag = row.rawValue
        case .metadata2:
            switchView.isOn = UserPreferences.shared.metadata2IsOn
            switchView.tag = row.rawValue
        case .items:
            switchView.isOn = UserPreferences.shared.itemsIsOn
            switchView.tag = row.rawValue
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
        if indexPath.section == 0,
            let row = DefaultSectionCellType(rawValue: indexPath.row) {
            switch row {
            case .publicToken, .timeOut, .paymentAmount:
                changeValue(cellType: row)
            case .theme:
                performSegue(withIdentifier: "changeColor", sender: nil)
            default:
                break
            }
        }
    }
    
    func changeValue(cellType: DefaultSectionCellType) {
        let alertController = UIAlertController(title: cellType.messageTitle, message: cellType.messageContent, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = cellType.title
            textField.keyboardType = cellType.keyBoard
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            if let text = textField.text, !text.isEmpty {
                switch cellType{
                case .publicToken:
                    UserPreferences.shared.publicToken = text
                case .timeOut:
                    if let seconds = ATHMCheckout.Seconds(text), seconds >= 60, seconds <= 600 {
                        UserPreferences.shared.timeOut =  seconds
                    } else {
                        self.invalidValueAlert(cellType)
                    }
                case .paymentAmount:
                    if let paymentAmount = Double(text) {
                        UserPreferences.shared.paymentAmount = paymentAmount
                    }
                default:
                    return
                }
                self.tableView.reloadData()
            }
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func invalidValueAlert(_ cellType: DefaultSectionCellType){
        let alertController = UIAlertController(title: cellType.messageTitle,
                                                message: cellType.messageContentError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
