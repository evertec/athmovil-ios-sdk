//
//  ATHMPaymentRequest.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/19/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import UIKit

protocol PaymentRequestable {
    /// Business account if the token account it is empty you will received an exception
    var businessAccount: ATHMBusinessAccount { get }
    /// Current application that will send the request to ATH Móvil Personal
    var scheme: ATHMURLScheme { get }
    /// Purchase representation to send to ATH Movil
    var payment: ATHMPayment { get }
    /// Purchase Timeout in ath movil personal
    var timeout: TimeInterval { get }
}

extension ATHMPaymentRequest: PaymentRequestable { }

extension ATHMPaymentRequest: PaymentRequestCodable {
    enum CodingKeys: CodingKey {
        case businessAccount, scheme, payment, timeout
    }
}

@objc(ATHMPaymentRequest)
public class ATHMPaymentRequest: NSObject {
    
    /// Business account if the token account it is empty you will received an exception
    let businessAccount: ATHMBusinessAccount
    
    /// Current application that will send the request to ATH Móvil Personal
    let scheme: ATHMURLScheme
    
    /// Purchase representation to send to ATH Movil
    let payment: ATHMPayment
    
    /// Current version of the payment request, it is only for ATH Movil personal
    let version = ATHMVersion.three
        
    /// Purchase Timeout in ath movil personal
    @objc public var timeout: TimeInterval = 600.0
    
    override public var description: String {
        """
        Request:
            - timeout: \(timeout)
            - App: \(scheme.description)
            - Business: \(businessAccount.description)
            - Business: \(payment.description)
        """
    }
    
    /// Creates an instance of the representation of the request, it is needed the total and the business account and the appclient from comes the request, this constructor
    /// it is for make the request without the button, in this case the buttons is the classic with the languaje english by default
    /// - Parameters:
    ///   - account: Business account, it is needed the token
    ///   - scheme: URL Scheme to response after ATH Movil processed the payment
    ///   - payment: Current purchase to send to ath movil
    @objc
    required public init(account: ATHMBusinessAccount, scheme: ATHMURLScheme, payment: ATHMPayment) {
        
        self.businessAccount = account
        self.scheme = scheme
        self.payment = payment
        
        super.init()
    }
    
    /// Send the payment to ATH Movil personal, waiting for a response in a ATHMPaymentResponse
    /// - Parameter handler: Closure to call after the response of the ATH Movil
    @objc
    public func pay(handler: ATHMPaymentHandler) {
                
        sendPayment(handler, urlopener: UIApplication.shared)
    }
    
    /// Send the payment to ATH Movil personal, waiting for a response in a NSDictionary
    /// - Parameter handler: Closure to call after the response of the ATH Movil the response is going to be in dictionary
    @objc
    public func pay(dictionaryHandler handler: ATHMPaymentHandlerDictionary) {
                
        sendPayment(handler, urlopener: UIApplication.shared)
    }
}

// MARK: Generic Method
extension ATHMPaymentRequest {
    
    /// This method encode the Payment request into a URL Scheme or Universal links depends on the request, also save the request for the response.
    /// The handler is the UIApplication and handler it could be the ATHMPaymentHandler or ATHMPaymentHandlerDictionary
    /// - Parameters:
    ///   - handler: handler to use when the SDK completed the payment
    ///   - urlopener: object to open the application
    func sendPayment<Handler, Opener>(_ handler: Handler, urlopener: Opener) where Handler: PaymentHandleable,
                                                                                   Opener: URLOpenerAdaptable {
        switch businessAccount.isSimulatedToken {
            case false:
                let paymentSender = AnyPaymentSender(paymentRequest: self,
                                                     paymentHandler: handler,
                                                     paymentOpener: urlopener)
                paymentSender.sendPayment(target: TargetUniversalLinks.athMovil, session: .shared)
                
            default:
                let paymentSimulated = PaymentSimulated(paymentRequest: self)
                let paymentSender = AnyPaymentSender(paymentRequest: paymentSimulated,
                                                     paymentHandler: handler,
                                                     paymentOpener: urlopener)
                paymentSender.sendPayment(target: TargetUniversalLinks.athMovilSimulated, session: .shared)
        }
    }
}
