//
//  PaymentEnviroment.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation



protocol PaymentEnviromentRepresentable {
    
    associatedtype Payment: PaymentRequestCodable
    
    var payment: Payment { get set }
    
    var athMovilAppURL: String { get }
    
    /**
     Get the url presentation of the payment
     - Returns:a tuple with the url request of the payment if the url can not be represented would be nil otherwise reutns a valid URL
     error if there is an error while encode the payment object
     */
    func urlRepresentation() -> (paymentURL: URL?, error: ATHMPaymentError?)
}

extension PaymentEnviromentRepresentable{
    
    ///URL of the app store
   var appStoreURL: URL { URL(string: "itms://itunes.apple.com/sg/app/ath-movil/id658539297?l=zh&mt=8")!  }
       
   
    
    /**
     Get the url presentation of the payment
     - Returns: tuple with the url request of the payment if the url can not be represented would be nil otherwise reutns a valid URL
     error if there is an error while encode the payment object
     */
    func urlRepresentation() -> (paymentURL: URL?, error: ATHMPaymentError?){
        
        do {
            let jsonEncoder = JSONEncoder()
            let paymentData = try jsonEncoder.encode(payment)
            var urlComponents = URLComponents(string: self.athMovilAppURL)
            
            guard let params = String(data: paymentData,
                                      encoding: .utf8) else{
                    
                let paymentError = ATHMPaymentError(message: "The request containts invalid characters",
                                                    source: .request)
                return (paymentURL: nil, error: paymentError)
            }
            
            urlComponents?.queryItems = [URLQueryItem(name: "transaction_data", value: params)]
            
            return (paymentURL:  urlComponents?.url, error: nil)
            
        } catch let error as ATHMPaymentError {
            return (paymentURL: nil, error: error)
            
        } catch let error as NSError {
            
            let message = error.debugDescription
            let paymentError = ATHMPaymentError(message: message, source: .request)
            return (paymentURL: nil, error: paymentError)
        }
    }
}


struct ATHMovilEnviroment<P>: PaymentEnviromentRepresentable where P:PaymentRequestCodable{

    var payment: P
    
    ///URL of the ath movil
    var athMovilAppURL: String { "athm://payment/" }
    
    init(payment: P){
        self.payment = payment
    }

}

struct SimulatedEnviroment<P>: PaymentEnviromentRepresentable where P:PaymentRequestCodable{
    
    ///URL of the ath movil
    var athMovilAppURL: String { "athm-simulator://payment/" }
    
    var payment: P
    
    init(payment: P)  {
        self.payment = payment
    }

}


