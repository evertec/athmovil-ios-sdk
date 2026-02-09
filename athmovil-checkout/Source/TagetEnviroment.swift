//
//  TagetEnviroment.swift
//  athmovil-checkout
//
//  Created by Hansy on 8/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

enum TargetEnviroment: String, CaseIterable {
    case custom
    case pilot
    case production
    
    static var selectedEnviroment: TargetEnviroment = .production
}

extension TargetEnviroment {
    
    static var trustedDomains: Set<String> = {
        TargetEnviroment.allCases.reduce(Set<String>()) { partialResult, target in
            var result = partialResult
            if let host = target.baseURL.host {
                result.insert(host)
            }
            result.insert(target.baseUrlAWS)
            return result
        }
    }()
    
    var baseURL: URL {
        switch self {
            case .pilot:
                return URL(string: "https://piloto.athmovil.com/rs/")!
            default:
                return URL(string: "https://www.athmovil.com/rs/")!
        }
    }
    
    var baseUrlAWS: String {
        switch self {
            case .pilot:
                return  "payments.athmovil.com"
            default:
                return "payments.athmovil.com"
        }
    }
    
    var athMovilURL: String {
        switch self {
            case .pilot:
                return "https://athmovil-ios-pilot.web.app/e-commerce"
            default:
                return "https://athmovil-ios.web.app/e-commerce"
        }
    }
    
    func client(
        currentRequest: PaymentRequestable
    ) -> APIClientRequestable {
        switch (self, currentRequest.businessAccount.isSimulatedToken) {
            case (_, true):
                return APIClientSimulated(paymentRequest: currentRequest)
            default:
                return APIPayments.api
        }
    }
    
    func client(
        currentRequest: PaymentSecureRequestable
    ) -> APIClientRequestable { APIPayments.apiAWS }
}
