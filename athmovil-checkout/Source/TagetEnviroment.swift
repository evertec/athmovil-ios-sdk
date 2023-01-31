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
    case quality
    case pilot
    case production
    
    static var selectedEnviroment: TargetEnviroment = .production
}

extension TargetEnviroment {
    
    var baseURL: URL {
        switch self {
            case .quality:
                return URL(string: "https://dev.athmovil.com/rs/")!
            case .pilot:
                return URL(string: "https://piloto.athmovil.com/rs/")!
            default:
                return URL(string: "https://www.athmovil.com/rs/")!
        }
    }
    
    var athMovilURL: String {
        switch self {
            case .quality:
                return "https://athm-ulink-test-static-website.s3.amazonaws.com/e-commerce"
            default:
                return "https://athm-ulink-prod-static-website.s3.amazonaws.com/e-commerce"
        }
    }
    
    func client(currentRequest: PaymentRequestable) -> APIClientRequestable {
        switch (self, currentRequest.businessAccount.isSimulatedToken) {
            case (_, true):
                return APIClientSimulated(paymentRequest: currentRequest)
            case (.quality, _):
                return APIPayments.apiQuality
            default:
                return APIPayments.api
        }
    }
    
    func client(currentRequest: PaymentSecureRequestable) -> APIClientRequestable {
        return APIPayments.apiCustom
    }
    
}
