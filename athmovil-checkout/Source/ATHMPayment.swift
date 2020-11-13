//
//  ATHMPurchase.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/17/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


@objc(ATHMPayment)
public class ATHMPayment: NSObject{
    
    ///Total of the transaction, it is not calculated in the items
    @objc public let total: NSNumber
    
    ///Purchase subtotal in case the client would not need the subtotal can send as null
    @objc public var subtotal: NSNumber = NSNumber(value: 0.0)
    
    ///Purchase Tax it could be null and the tax would no send to ATH Movil
    @objc public var tax: NSNumber = NSNumber(value: 0.0)
    
    ///Fee amount of the payment
    @objc public var fee: NSNumber = NSNumber(value: 0.0)
    
    ///Net amount of the payment it means total - fee
    @objc public var netAmount: NSNumber = NSNumber(value: 0.0)
    
    ///Purchase items the client could send the list empty and ATH Movil personal will response with the items
    @objc public var items: [ATHMPaymentItem] = [ATHMPaymentItem]()
    
    ///Purchase additional information one it could be null, if the client will send something ATH Movil Personal is going to return the information
    @objc public var metadata1: String = ""
    
    ///Purchase additional information two it could be null, if the client will send something ATH Movil Personal is going to return the information
    @objc public var metadata2: String = ""
    
    @objc public override var description: String{
        """
        Payment:
            - total: \(total.doubleValue)
            - subtotal: \(subtotal.doubleValue)
            - tax: \(tax.doubleValue)
            - fee: \(fee.doubleValue)
            - netAmount: \(netAmount.doubleValue)
            - metadata1: \(metadata1)
            - metadata2: \(metadata1)
            \(items.description)
        """
    }
    
    /**
     Creates an instance of the representation of the purchase, it is needed the total and the business account and the appclient from comes the request
        - Parameters:
         - total: Purchases total it has to be greater than zero
         - account: Business account, it is needed the token
         - appClient: Third app client
     */
    @objc required public init(total: NSNumber){
        
        self.total = total

        super.init()
        
    }
        
}


