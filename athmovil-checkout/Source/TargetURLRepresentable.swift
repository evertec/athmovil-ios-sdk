//
//  TargetURLRepresentable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol TargetURLRepresentable {
        
    /// URL of ATH Movil for ATH Movil application it is in ATHMovilTarget, simulated request it is in SimulatedTarget
    var athMovilAppURL: String { get }
    
    /// Dictionary with the options to send when the SKD will open ATH Movil Personal
    var options: [UIApplication.OpenExternalURLOptionsKey : Any] { get }
            
    func open<Payment, Opener>(payment: Payment,
                               application: Opener,
                               completion: @escaping (Result<URL, ATHMPaymentError>) -> Void) where Payment: Encodable,
                                                                                                    Opener: URLOpenerAdaptable
}

extension TargetURLRepresentable {
    
    /// URL of the app store
   var appStoreURL: URL { URL(string: "itms://itunes.apple.com/sg/app/ath-movil/id658539297?l=zh&mt=8")! }
    
    /// Dictionary with the options to send when the SKD will open ATH Movil Personal
    var options: [UIApplication.OpenExternalURLOptionsKey : Any] { [:] }
           
    /// Convert the parameter payment an URL with all parameters using JSONEncoder
    /// - Parameter payment: current payment of the button in this case always it is going to be AnyPaymentRequestCoder
    /// - Returns: Returns .failure in case the encode has errors or some property has invalid data otherwise return .success wirh the URL
    func urlRepresentation<T>(_ payment: T) -> Result<URL, ATHMPaymentError> where T: Encodable {
        
        do {
            let jsonEncoder = JSONEncoder()
            let paymentData = try jsonEncoder.encode(payment)
            var urlComponents = URLComponents(string: athMovilAppURL)
            
            guard let params = String(data: paymentData,
                                      encoding: .utf8) else {
                
                let paymentError = ATHMPaymentError(message: "The request containts invalid characters",
                                                    source: .request)
                return .failure(paymentError)
            }
            
            urlComponents?.queryItems = [URLQueryItem(name: "transaction_data", value: params)]
            
            return .success(urlComponents?.url ?? URL(fileURLWithPath: ""))
            
        } catch let error as ATHMPaymentError {
            return .failure(error)
            
        } catch let error as NSError {
            
            let message = error.debugDescription
            let paymentError = ATHMPaymentError(message: message, source: .request)
            return .failure(paymentError)
        }
    }
    
    /// Open ATH Movil application with the payment content, the parameter application is the UIApplication.shared
    /// - Parameters:
    ///   - payment: current payment of the user
    ///   - application: current UIApplicaiton.shared that will open ATH Movil Person otherwise will try to open App Store
    ///   - completion: after ATH Movil Personal is open the SDK is going to save the current request in memory
    func open<Payment, Opener>(payment: Payment,
                               application: Opener,
                               completion: @escaping (Result<URL, ATHMPaymentError>) -> Void) where Payment: Encodable,
                                                                                                    Opener: URLOpenerAdaptable {
        let request = urlRepresentation(payment)
        
        switch request {
            case let .success(url):
                application.open(url: url, alternateURL: appStoreURL, options: options) { success in
                    
                    if success {
                        completion(.success(url))
                    }
                }
                
            case let .failure(error):
                return completion(.failure(error))
        }
    }
}

enum TargetURLScheme: TargetURLRepresentable, CaseIterable {
    
    case athMovil
    case athMovilSimulated
    
    var athMovilAppURL: String {
        switch self {
            case .athMovil:
                return "athm://payment/"
            case .athMovilSimulated:
                return "athm://paymentSimulated/"
        }
    }
}

enum TargetUniversalLinks: TargetURLRepresentable, CaseIterable {
    case athMovil
    case athMovilSimulated
    
    /// Dictionary with the options to send when the SKD will open ATH Movil Personal
    var options: [UIApplication.OpenExternalURLOptionsKey : Any] {
        [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly:  true]
    }
    
    var athMovilAppURL: String {
        switch self {
            case .athMovil:
                return "https://athm-ulink-prod-static-website.s3.amazonaws.com/e-commerce/mobile"
            case .athMovilSimulated:
                return "https://athm-ulink-prod-static-website.s3.amazonaws.com/e-commerce/mobileDummy"
        }
    }
}
