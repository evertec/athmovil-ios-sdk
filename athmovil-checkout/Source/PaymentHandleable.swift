//
//  PaymentHandleable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 9/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentHandleable {
    
    ///it is going to call when the there is error in the request or in the response from ATH Movil
    var onException: (_ response: ATHMPaymentError) -> () { get set }
    
    /**
     Method to confirm the payment to ATH Movil
     - Parameters:
         - from data form the url
     */
    func confirm(from athMovilData: Data)
    
}

