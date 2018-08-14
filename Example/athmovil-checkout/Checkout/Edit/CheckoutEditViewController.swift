//
//  CheckoutEditViewController.swift
//  athm-checkout-demo
//
//  Created by Leonardo Maldonado on 5/5/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

enum DefaultSectionCellType: Int {
    case tax
    case subTotal
    case items
    
    var title: String {
        switch self {
        case .tax:
            return "Tax"
        case .subTotal:
            return "Subtotal"
        case .items:
            return "items"
        }
    }
    
    static var count: Int {
        return DefaultSectionCellType.items.rawValue + 1
    }
}

protocol CheckoutEditDelegate: class {
    func didUpdatePreferences(_ pref: (Bool, Bool, Bool))
}

class CheckoutEditViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userPref = (taxIsOn: true,
                    subTotalIsOn: true,
                    itemsIsOn: true)
    
    weak var delegate: CheckoutEditDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        self.title = "Optional Parameters"
    }
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionFooterHeight = 96;
        let checkoutEditFooterNibName = "CheckoutEditFooterTableViewCell"
        let checkoutEditFooterNib = UINib(
            nibName: checkoutEditFooterNibName, bundle: nil)
        tableView.register(checkoutEditFooterNib, forCellReuseIdentifier:
            CheckoutEditFooterTableViewCell.reuseIdentifier)
    }
    
    @objc fileprivate func accesoryViewChanged(_ sender: UISwitch) {
        let cellType = DefaultSectionCellType(rawValue: sender.tag)
        switch cellType {
        case .tax?:
            userPref.taxIsOn = sender.isOn
            delegate?.didUpdatePreferences(userPref)
        case .subTotal?:
            userPref.subTotalIsOn = sender.isOn
            delegate?.didUpdatePreferences(userPref)
        case .items?:
            userPref.itemsIsOn = sender.isOn
            delegate?.didUpdatePreferences(userPref)
        case .none:
            return
        }
    }
}

extension CheckoutEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
        return DefaultSectionCellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let switchView = UISwitch()
        switchView.addTarget(self, action:
            #selector(accesoryViewChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        cell.selectionStyle = .none
        cell.accessoryView?.tag = indexPath.row
        let row = DefaultSectionCellType(
            rawValue: indexPath.row)
        
        switch row {
        case .tax?:
            cell.textLabel?.text = row?.title
            switchView.isOn = userPref.taxIsOn
            break
        case .subTotal?:
            cell.textLabel?.text = row?.title
            switchView.isOn = userPref.subTotalIsOn
        case .items?:
            cell.textLabel?.text = row?.title
            switchView.isOn = userPref.itemsIsOn
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}

extension CheckoutEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section:
        Int) -> UIView? {
        let reuseIdentifier = CheckoutEditFooterTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier)
            as! CheckoutEditFooterTableViewCell
        return cell.contentView
    }
}
