//
//  ATHMPaymentDictionaryRequestSimulated.swift
//  athmovil-checkout
//
//  Created by Eliezer Ferra on 1/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentDictionaryRequestSimulated)
public class ATHMPaymentDictionaryRequestSimulated: NSObject{
        
    ///Purchase representation to send to ATH Movil
    let requestDictionary: NSDictionary
        
    ///Purchase Timeout in ath movil personal
    @objc public var timeout: TimeInterval = 600.0
    
    override public var description: String{
        """
        Request:
            - timeout: \(timeout)
            - dictionary: \(requestDictionary)
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
    @objc required public init(dictionary: NSDictionary){
        self.requestDictionary = dictionary
        super.init()
    }
    
    /**
     Send the payment to ATH Movil personal
     - Parameters:
         - handler: Closure to call after the response of the ATH Movil
     */
    @objc public func paySimulated(handler: ATHMPaymentHandlerDictionary){
        self.sendPayment(handler: handler)
    }
    
    /**
    Send the payment to ATH Movil personal
    - Parameters:
        - url: Url to send the payment in this case is for ATH Movil QA or production
        - urlAdaptable: Object that will open the application of the ath movil
        - session: Session handler its containts the payments references
    */
    func sendPayment(handler: ATHMPaymentHandlerDictionary,
                     urlAdaptable: URLOpenerAdaptable = URLOpener(application: UIApplication.shared),
                     session: ATHMPaymentSession = .shared){
        guard let params = self.getParametersPayment() else{
            let paymentError = ATHMPaymentError(message: "There was an error sending the request",
                                                source: .request)
            handler.onException(paymentError)
            return
        }
        
        let payment = AnyPaymentRequestCoder(business: BusinessAccountCoder(business: params.business),
                                             client: ClientAppCoder(clientAPP: params.client),
                                             payment: PaymentCoder(payment: params.payment),
                                             timeout: timeout)
                
        let paymentSender = AnyPaymentSender()
        paymentSender.sendPayment(enviroment: SimulatedEnviroment(payment: payment), handler: handler)
    }
    
    /**
     Convert the disctionary to request objects
     - Returns: a tuple with all the information of the payment such as the business object, client object and payment information
     */
    func getParametersPayment() -> (business: ATHMBusinessAccount, client: ATHMClientApp, payment: ATHMPayment)?{
        
        do {
            let business = ATHMBusinessAccount(token: (self.requestDictionary["publicToken"] as? String) ?? "")
            
            let client = ATHMClientApp(urlScheme: (self.requestDictionary["scheme"] as? String) ?? "")
            
            let dataSerialization = try JSONSerialization.data(withJSONObject: self.requestDictionary,
                                                               options: .prettyPrinted)
            let decoder = JSONDecoder()
            let payment = try decoder.decode(PaymentCoder.self, from: dataSerialization)
            
            return (business: business, client: client, payment: payment.payment)
            
        } catch  {
            return nil
        }
    }
}
