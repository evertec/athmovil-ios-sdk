//
//  ATHMPaymentRequest.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/19/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import UIKit


@objc(ATHMPaymentRequest)
public class ATHMPaymentRequest: NSObject{
    
    ///Business account if the token account it is empty you will received an exception
    let businessAccount: ATHMBusinessAccount
    
    ///Current application that will send the request to ATH Móvil Personal
    let appClient: ATHMClientApp
    
    ///Purchase representation to send to ATH Movil
    let payment: ATHMPayment
        
    ///Purchase Timeout in ath movil personal
    @objc public var timeout: TimeInterval = 600.0
    
    
    override public var description: String{
        """
        Request:
            - timeout: \(timeout)
            - App: \(appClient.description)
            - Business: \(businessAccount.description)
            - Business: \(payment.description)
        """
    }
    
    /**
     Creates an instance of the representation of the request, it is needed the total and the business account and the appclient from comes the request, this constructor
     it is for make the request without the button, in this case the buttons is the classic with the languaje english by default
        - Parameters:
         - account: Business account, it is needed the token
         - appClient: Third app client
         - payment: Current purchase to send to ath movil
     */
    @objc required public init(account: ATHMBusinessAccount, appClient: ATHMClientApp, payment: ATHMPayment){
        
        self.businessAccount = account
        self.appClient = appClient
        self.payment = payment
        
        super.init()
        
    }
    
    /**
     Send the payment to ATH Movil personal
     - Parameters:
         - handler: Closure to call after the response of the ATH Movil
     */
    @objc public func pay(handler: ATHMPaymentHandler){
        
        self.sendPayment(handler: handler)
    }
    
    /**
    Send the payment to ATH Movil personal
    - Parameters:
        - url: Url to send the payment in this case is for ATH Movil QA or production
        - urlAdaptable: Object that will open the application of the ath movil
        - session: Session handler its containts the payments references
    */
    func sendPayment(handler: ATHMPaymentHandler,
                    urlAdaptable: URLOpenerAdaptable = URLOpener(application: UIApplication.shared),
                    session: ATHMPaymentSession = .shared){

        let payment = AnyPaymentRequestCoder(business: BusinessAccountCoder(business: self.businessAccount),
                                             client: ClientAppCoder(clientAPP: self.appClient),
                                             payment: PaymentCoder(payment: self.payment),
                                             timeout: timeout)

        let paymentSender = AnyPaymentSender()
        
        paymentSender.sendPayment(enviroment: ATHMovilEnviroment(payment: payment), handler: handler)

    }
    
}




