//
//  ATHMPaymentSecureRequest.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 4/10/22.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import UIKit

protocol PaymentSecureRequestable {
    /// Business account if the token account it is empty you will received an exception
    var businessAccount: ATHMBusinessAccount { get }
    /// Current application that will send the request to ATH Móvil Personal
    var scheme: ATHMURLScheme { get }
    /// Purchase representation to send to ATH Movil
    var payment: ATHMSecurePayment { get }
    /// Purchase old representation to send to registration payment services
    var paymentRequest: ATHMSendPayment { get }
    /// Purchase old representation to response error status
    var paymentOld: ATHMPayment { get }
    /// Purchase Timeout in ath movil personal
    var timeout: TimeInterval { get }
}

extension ATHMPaymentSecureRequest: PaymentSecureRequestable { }

extension ATHMPaymentSecureRequest: PaymentSecureRequestCodable {
    enum CodingKeys: CodingKey {
        case businessAccount, scheme, payment, paymentOld, timeout
    }
}

@objc(ATHMPaymentSecureRequest)
public class ATHMPaymentSecureRequest: NSObject {
    
    /// Business account if the token account it is empty you will received an exception
    let businessAccount: ATHMBusinessAccount
    /// Current application that will send the request to ATH Móvil Personal
    let scheme: ATHMURLScheme
    /// Purchase representation to send to ATH Movil
    var payment: ATHMSecurePayment
    /// Purchase old representation to send to registration payment services
    var paymentRequest: ATHMSendPayment
    /// Purchase old representation to response error status
    var paymentOld: ATHMPayment
    /// Current version of the payment request, it is only for ATH Movil personal
    let version = ATHMVersion.three
                
    fileprivate var userPref = UserPreferences.shared
    
    /// Purchase Timeout in ath movil personal
    @objc public var timeout: TimeInterval = 600.0
    
    override public var description: String {
        """
        Request:
            - Business: \(businessAccount.description)
            - App: \(scheme.description)
            - Payment: \(payment.description)
            - PaymentOld: \(paymentOld.description)
            - timeout: \(timeout)
            - version: \(version)
        """
    }
    
    /// Creates an instance of the representation of the request, it is needed the total and the business account and the appclient from comes the request, this constructor
    /// it is for make the request without the button, in this case the buttons is the classic with the languaje english by default
    /// - Parameters:
    ///   - account: Business account, it is needed the token
    ///   - scheme: URL Scheme to response after ATH Movil processed the payment
    ///   - payment: Current purchase to send to ath movil
    @objc
    required public init(account: ATHMBusinessAccount,scheme: ATHMURLScheme, payment: ATHMPayment) {
        self.businessAccount = account
        self.scheme = scheme
        let paymentSecure = ATHMSecurePayment()        
        paymentSecure.phoneNumber = payment.phoneNumber
        paymentSecure.scheme = scheme.urlScheme
        paymentSecure.publicToken = account.token
        paymentSecure.timeout = timeout
        paymentSecure.version = version
        self.payment = paymentSecure
        self.paymentOld = payment
        let paymentRequest = ATHMSendPayment(total: payment.total.doubleValue)
        let env = TargetEnviroment(rawValue: ATHMPaymentSession.shared.enviroment.lowercased()) ?? .production
        paymentRequest.env = env.rawValue
        paymentRequest.phoneNumber = payment.phoneNumber
        paymentRequest.publicToken = account.token
        paymentRequest.metadata1 = payment.metadata1
        paymentRequest.metadata2 = payment.metadata2
        paymentRequest.subtotal = payment.subtotal.doubleValue
        paymentRequest.tax = payment.tax.doubleValue
        paymentRequest.items = payment.items
        self.paymentRequest = paymentRequest
        super.init()
    }
    
    /// Send the payment to ATH Movil personal, waiting for a response in a ATHMPaymentResponse
    /// - Parameter handler: Closure to call after the response of the ATH Movil
    @objc
    public func pay(handler: ATHMPaymentHandler) {
        var target = TargetEnviroment(rawValue: ATHMPaymentSession.shared.enviroment.lowercased()) ?? .production
        target.self = .custom
        let apiForOnResume = target.client(currentRequest: self)
        
        apiForOnResume.send(request: .payment(currentPayment: self,
        completion: { result in
            DispatchQueue.main.sync {
                switch result {
                    case let .success(response):
                        //SAVE AUTHTOKEN
                        self.userPref.authToken = response.data.authToken
                        //SET ECOMMERCEID
                        self.payment.ecommerceId = response.data.ecommerceID
                        self.sendPayment(handler, urlopener: UIApplication.shared)
                    case let .failure(error):
                        handler.onException(error)
                }
            }
        }))
    }
}

// MARK: Generic Method
extension ATHMPaymentSecureRequest {
    
    /// This method encode the Payment request into a URL Scheme or Universal links depends on the request, also save the request for the response.
    /// The handler is the UIApplication and handler it could be the ATHMPaymentHandler or ATHMPaymentHandlerDictionary
    /// - Parameters:
    ///   - handler: handler to use when the SDK completed the payment
    ///   - urlopener: object to open the application
    func sendPayment<Handler, Opener>(_ handler: Handler, urlopener: Opener) where Handler: PaymentHandleable,
                                                                                   Opener: URLOpenerAdaptable {
        let target = TargetEnviroment(rawValue: ATHMPaymentSession.shared.enviroment.lowercased()) ?? .production
           TargetEnviroment.selectedEnviroment = target

       let paymentSender = AnyPaymentSecureSender(paymentRequest: self,
                                            paymentHandler: handler,
                                            paymentOpener: urlopener)
       
       paymentSender.sendPayment(target: TargetUniversalLinks.athMovilSecure(target),
                                 session: .shared)
    }
}
