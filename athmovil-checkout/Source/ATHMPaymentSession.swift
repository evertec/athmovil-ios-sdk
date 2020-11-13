//
//  ATHMPaymentSession.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation


@objc(ATHMPaymentSession)
public class ATHMPaymentSession: NSObject {
    
    /// Parameter :
    /// shared:  Singleton instance
    @objc public static let shared = ATHMPaymentSession()
    
    ///Queue to store the request of the payment button, it
    private(set) var handlerQueue = Array<PaymentHandleable>()
    
    ///Set this property after the client app had been recevied the response from ATH Movil, after that the application is going to recieve  the response
    @objc public var url: URL?{
        willSet{
            guard let newURL = newValue else{
                return
            }
            
            DispatchQueue.global().async { [unowned self] in
                self.dispatch(url: newURL)
            }
        }
    }
    
    /**
     Dispatch the url from ATH Movil, it there are not request in the requestQueue the method will abort furthermore if the data's url is no from ath movil the method
        is going to discard the request
     - Parameters:
     - url: ATHM movil response
     */
    private func dispatch(url: URL){
                
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        guard let dataFromATHM = urlComponents?.isATHMovil(),
              let currentHandler = handlerQueue.popLast() else{
            return
        }
        
        currentHandler.confirm(from: dataFromATHM)
    }
    
    /**
     Add the new handler to the array and remove the old requests
     - Parameters:
     - handler object to handle the payment response
     */
    func register(handler: PaymentHandleable){
        
        if self.handlerQueue.count >= 1{
            self.handlerQueue.removeAll()
        }
        
        self.handlerQueue.append(handler)
    }

}
