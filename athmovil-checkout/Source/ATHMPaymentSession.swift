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
    
    @objc
    public static let shared = ATHMPaymentSession()
    
    @objc
    public var enviroment: String = TargetEnviroment.production.rawValue
    
    /// Payment API for getting the payment status in the server
    let paymentAPI = APIPayments.api
    var observerBecomeActive: NSObjectProtocol?

    /// Queue for processing the responses of ATH Movil
    private let queueResponse = DispatchQueue(label: "com.evertecinc.ATHMovil.SDK",
                                              qos: .background)
    
    /// This property avoid to make other request while the web service is getting the payment status.
    private var _isWaitingForService: Bool = false
    var isWaiting: Bool {
        get {
            queueResponse.sync { return _isWaitingForService }
        }
        set(newValue) {
            queueResponse.sync { _isWaitingForService = newValue }
        }
    }
    
    /// Property to save the current, this object only allow one request at once
    var currentPayment: AnyPaymentReceiver? {
        
        didSet {
            addObserverForBecomeActive()
        }
    }
    
    /// Property to save the current, this object only allow one request at once
    var currentSecurePayment: AnyPaymentSecureReceiver? {
        
        didSet {
            addObserverForBecomeActive()
        }
    }
    
    /// When the ATHMPaymentSession has pending payment this class add a observer for UIApplication.didBecomeActiveNotification in case when the user or
    /// ATH Movil Application does not completed the payment so the SDK will call a web service to get the payment status after that will response the business application
    /// as usual
    /// - Parameter notification: Notification center to use by default is default
    func addObserverForBecomeActive(notification: NotificationCenter = .default) {
        
        guard currentPayment != nil || currentSecurePayment != nil else {
            return
        }
        
        observerBecomeActive = notification.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                                        object: nil,
                                                        queue: nil) { _ in
            if let observer = self.observerBecomeActive {
                notification.removeObserver(observer)
                self.observerBecomeActive = nil
            }
                        
            if(self.currentPayment == nil){
                let anyResponsePayment = self.currentSecurePayment
                anyResponsePayment?.completed(by: .becomeActive)
            }else{
                let anyResponsePayment = self.currentPayment
                self.currentPayment = nil
                anyResponsePayment?.completed(by: .becomeActive)
            }
           
        }
        
    }
    
    /// Set this property after the client app had been recevied the response from ATH Movil, after that the client's application is going to recieve  the response by the
    /// ATHMPaymentHandler or dictionary Handler
    @objc
    public var url: URL? {
        willSet {
            guard let dataFromATHMovil = newValue?.responseFromATHM else {
                return
            }
            if(currentPayment == nil){
                let anyResponsePayment = currentSecurePayment
                anyResponsePayment?.completed(by: .deepLink(dataFromATHMovil))
            }else{
                let anyResponsePayment = currentPayment
                currentPayment = nil
                anyResponsePayment?.completed(by: .deepLink(dataFromATHMovil))
            }
        }
    }
}
