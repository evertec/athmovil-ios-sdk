//
//  SelectThemeViewController.swift
//  athmovil-checkout_Example
//
//  Created by Cristopher Bautista on 1/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import athm_checkout

class SelectThemeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let theme = AMCheckoutButtonStyle(rawValue: indexPath.row) {
            cell.textLabel?.text = theme.name
            if UserPreferences.shared.theme == indexPath.row {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let theme = AMCheckoutButtonStyle(rawValue: indexPath.row) {
            UserPreferences.shared.theme = theme.rawValue
            tableView.reloadData()
        }
    }
}
