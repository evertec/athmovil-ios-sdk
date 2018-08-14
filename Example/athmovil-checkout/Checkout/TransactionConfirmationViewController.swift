//
//  TransactionConfirmationViewController.swift
//  ATHMovil
//
//  Created by Leonardo Maldonado on 5/1/18.
//  Copyright © 2018 EVERTEC, Inc. All rights reserved.
//

import UIKit

protocol TransactionConfirmationOutputs {
    
    /// Emits when the the done button is pressed.
    var done: (() -> Void)! { set get }
}

protocol TransactionConfirmationViewModelType {
    var outputs: TransactionConfirmationOutputs { set get }
}

class TransactionConfirmationViewController: UIViewController,
    TransactionConfirmationViewModelType, TransactionConfirmationOutputs {
  
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.image = self.iconImage
        }
    }
    
    @IBOutlet weak var primaryLabel: UILabel! {
        didSet {
            primaryLabel.text = self.primaryTitle
            primaryLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var secondaryLabel: UILabel! {
        didSet {
            secondaryLabel.text = self.secondaryTitle
            secondaryLabel.numberOfLines = 0
            secondaryLabel.textAlignment = .center
        }
    }
    
    var primaryTitle: String?
    var secondaryTitle: String?
    var iconImage: UIImage?
    var backgroundColor: UIColor?
    var done: (() -> Void)!
    
    var outputs: TransactionConfirmationOutputs {
        set { /* Required **/ } get { return self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        /// Setup verifyButton UI
        self.doneButton.tintColor = UIColor.white
        let buttonTitle = "Done"
        self.doneButton.setTitle(buttonTitle, for: UIControlState.normal)
        self.doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        if backgroundColor != nil {
            self.doneButton.backgroundColor = backgroundColor
        }else {
            self.doneButton.backgroundColor = .default
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.done()
    }
}
