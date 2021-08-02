//
//  AnyPaymentSender.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 9/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

struct AnyPaymentSender<Payment, Handler, Opener> where Payment: PaymentRequestCodable,
                                                Payment: PaymentRequestable,
                                                Handler: PaymentHandleable,
                                                Opener: URLOpenerAdaptable {
    
    /// Current payment of the user it is going to be an object of type ATHMPaymentRequest
    let paymentRequest: Payment
    
    /// The handlers, there is two types of handlers dictionary and standar
    let paymentHandler: Handler
    
    let paymentOpener: Opener
    
    /// Send the payment to ATH Movil Personal with URL scheme
    /// - Parameters:
    ///   - target: URL Scheme of the AHT Movil Personal
    ///   - session: current payment session
    func sendPayment(target: TargetURLScheme, session: ATHMPaymentSession) {
        send(target: target, session: session, application: paymentOpener)
    }
    
    /// Send the payment to ATH Movil Personal with universal links
    /// - Parameters:
    ///   - target: Universal link of the AHT Movil Personal
    ///   - session: current payment session
    func sendPayment(target: TargetUniversalLinks, session: ATHMPaymentSession) {
        send(target: target, session: session, application: paymentOpener)
    }
    
    /// Encode the ATHMPaymentRequest to JSON, create the URL and send the payment to ATH Movil Personal
    /// - Parameters:
    ///   - target: current target to open, the target always is going to be ATH Movil but it could be open by URL Scheme o Universal Links
    ///   - session: current payment session
    ///   - application: current application
    private func send<Target, Opener>(target: Target,
                                      session: ATHMPaymentSession,
                                      application: Opener) where Target: TargetURLRepresentable,
                                                                 Opener: URLOpenerAdaptable {
        
        guard !session.isWaiting else {
            return
        }
        
        let anyPaymentRequest = AnyPaymentRequestCoder(paymentRequest: paymentRequest,
                                                       traceId: paymentHandler.traceId.uuidString)
        
        target.open(payment: anyPaymentRequest, application: application) { result in
            
            switch result {
                case .success:
                    session.currentPayment = AnyPaymentReceiver(paymentContent: paymentRequest,
                                                                handler: paymentHandler,
                                                                session: session)
                case let .failure(paymentError):
                    paymentHandler.onException(paymentError)
            }
        }
    }
}
