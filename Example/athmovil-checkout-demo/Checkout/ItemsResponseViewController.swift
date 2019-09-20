//
//  ItemsResponseViewController.swift
//  checkout-demo-swift
//
//  Created by Cristopher Bautista on 4/17/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import UIKit
import athmovil_checkout

class ItemsResponseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [ATHMPaymentItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupNavigationBar() {
        title = "Items"
        let chevronIcon = UIImage(named: "ic_chevron")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: chevronIcon , style: .plain, target:
            self, action: #selector(chevronIconPressed))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func chevronIconPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ItemsResponseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let myCell = cell as! ItemResponseCell
        myCell.configure(item: items![indexPath.row])
    }
}

extension ItemsResponseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ItemResponseCell", for: indexPath) as! ItemResponseCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
}

class ItemResponseCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configure(item: ATHMPaymentItem) {
        nameLabel.text = item.name
        descLabel.text = item.desc
        quantityLabel.text = "x\(item.quantity)"
        priceLabel.text = String(format: "$ %.2f", item.price.doubleValue)
    }
}
