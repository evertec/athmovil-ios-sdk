//
//  TagetEnviroment.swift
//  athmovil-checkout
//
//  Created by Hansy on 8/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

enum TargetEnviroment: String, CaseIterable {
    
    case production
    
    static var selectedEnviroment: TargetEnviroment = .production
}

extension TargetEnviroment {
    
    var baseURL: URL {
        return URL(string: "https://www.athmovil.com/rs/")!
    }
    
    var baseUrlAWS: String {
        return "payments.athmovil.com"
    }
    
    var athMovilURL: String {
        return "https://athmovil-ios.web.app/e-commerce"
    }
    
    func client(currentRequest: PaymentRequestable) -> APIClientRequestable {
        return APIPayments.api
    }
    
    func client(currentRequest: PaymentSecureRequestable) -> APIClientRequestable {
        return APIPayments.apiCustom
    }
    
}
