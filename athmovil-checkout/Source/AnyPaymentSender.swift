//
//  AnyPaymentSender.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 9/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


struct AnyPaymentSender {
    
    /**
     Send the request to ATH Movil application or simulator depends on the enviroment
         - Parameters:
             - enviroment if you send simulated is going to open the simlulator otherwise aht movil application
             - handler  Object to handle the error in request or response and also the exception
             - urlAdaptable: Url adapter to open the applaction
             - session session to persis the handler
     */
    func sendPayment<Enviroment: PaymentEnviromentRepresentable, Payment>(enviroment: Enviroment,
                     handler: PaymentHandleable,
                     urlAdaptable: URLOpenerAdaptable = URLOpener(application: UIApplication.shared),
                     session: ATHMPaymentSession = .shared) where Enviroment.Payment == Payment {

        let paymentRepresentation = enviroment.urlRepresentation()

        switch paymentRepresentation {

            case (nil, let paymentError) where paymentError != nil:
                handler.onException(paymentError!)
                return

            case (let url, nil) where url != nil:

                session.register(handler: handler)

                urlAdaptable.openWebsite(url: url!,
                                         alternateURL: enviroment.appStoreURL,
                                         options: [:],
                                         completion: nil)
            default:
                let paymentError = ATHMPaymentError(message: "There was an error sending the request",
                                                    source: .request)
                handler.onException(paymentError)
        }
    }
}
