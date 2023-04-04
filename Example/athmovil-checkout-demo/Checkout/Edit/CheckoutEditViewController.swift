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
    
    let selectedNewFlow = UserPreferences.shared.newFlow
 
    var cellRows: [[DefaultSectionCellType]] = [[.publicToken,.timeOut,.paymentAmount,.theme, .enviroment, .newFlow],
                                                 [.subTotal,.tax,.metadata1,.metadata2]]
    
    var titleSection = ["CONFIGURATION","OPTIONAL PARAMETERS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedNewFlow == NewFlow.SI.rawValue){
            self.cellRows =  [[.publicToken,.timeOut,.paymentAmount,.theme, .enviroment, .newFlow],
                              [.subTotal,.tax,.metadata1,.metadata2,.phoneNumber]]
        }
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    fileprivate func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        let closeIcon = UIImage(named: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeIcon ,
                                                            style: .plain,
                                                            target:self,
                                                            action: #selector(closeIconPressed))
    }
    
    fileprivate func setupTableView() {
        tableView.sectionFooterHeight = UITableView.automaticDimension;
        tableView.estimatedSectionFooterHeight = 96;
        let checkoutEditFooterNibName = "CheckoutEditFooterTableViewCell"
        let checkoutEditFooterNib = UINib(
            nibName: checkoutEditFooterNibName, bundle: nil)
        tableView.register(checkoutEditFooterNib, forCellReuseIdentifier:
            CheckoutEditFooterTableViewCell.reuseIdentifier)
    }
    
    func setupLongPressGesture(subView: UIView) {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                                         action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.5
        longPressGesture.delegate = self
        subView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func closeIconPressed(){
        UserPreferences.shared.save()
        dismiss(animated: true, completion: nil)
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
        let alert = UIAlertController(title: "Payment Configuration",
                                      message: "Do you want to restore to preset configuration?", preferredStyle: .alert)
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
            cell.textLabel?.text = row.title
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.text = UserPreferences.shared.nameTheme
        case .enviroment:
                cell.textLabel?.text = row.title
                cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.text = UserPreferences.shared.enviroment
        case .newFlow:
                cell.textLabel?.text = row.title
                cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.text = UserPreferences.shared.newFlow
        // OPTIONAL PARAMETERS
        case .subTotal:
            inputCell(cell, title: row.title, value: "$\(UserPreferences.shared.subTotal)")
        case .tax:
            inputCell(cell, title: row.title, value: "$\(UserPreferences.shared.tax)")
        case .metadata1:
            inputCell(cell, title: row.title, value: UserPreferences.shared.metadata1)
        case .metadata2:
            inputCell(cell, title: row.title, value: UserPreferences.shared.metadata2)
        case .phoneNumber:
            inputCell(cell, title: row.title, value: UserPreferences.shared.phoneNumber)
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
    
    fileprivate func showConfigurable(type: selectableList, completion: @escaping (selectableList) -> Void) {
        let configViewController = ConfigurationListViewController(nibName: "ConfigurationListViewController",
                                                                   bundle: .main,
                                                                   typeList: type,
                                                                   completion: completion)
        
        configViewController.modalPresentationStyle = .overCurrentContext
        configViewController.modalTransitionStyle = .coverVertical
        present(configViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = cellRows[indexPath.section][indexPath.row]
        
        switch type {
            case .theme:
                let selectedTheme = UserPreferences.shared.getThemeName(index: UserPreferences.shared.theme)
                showConfigurable(type: .theme(selectedTheme)) { selectedType in
                    if case let .theme(newTheme) = selectedType {
                        UserPreferences.shared.theme = UserPreferences.shared.themeList.firstIndex(of: newTheme) ?? 0
                        tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            case .enviroment:
                let selectedEnv = UserPreferences.shared.enviroment
                showConfigurable(type: .enviroment(selectedEnv)) { selectedType in
                    if case let .enviroment(newEnv) = selectedType {
                        UserPreferences.shared.enviroment = newEnv
                        tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            case .newFlow:
                let selectedNewFlow = UserPreferences.shared.newFlow
                showConfigurable(type: .newFlow(selectedNewFlow)) { selectedType in
                    if case let .newFlow(newFlow) = selectedType {
                        UserPreferences.shared.newFlow = newFlow
                        if(newFlow == NewFlow.SI.rawValue){
                            self.cellRows =  [[.publicToken,.timeOut,.paymentAmount,.theme, .enviroment, .newFlow],
                                         [.subTotal,.tax,.metadata1,.metadata2,.phoneNumber]]
                        }else{
                            UserPreferences.shared.phoneNumber = ""
                            self.cellRows =  [[.publicToken,.timeOut,.paymentAmount,.theme, .enviroment, .newFlow],
                                         [.subTotal,.tax,.metadata1,.metadata2]]
                        }
                        tableView.reloadData()
                    }
                }
            default:
                changeValue(cellType: type)
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
                case .phoneNumber:
                    UserPreferences.shared.phoneNumber = text
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
