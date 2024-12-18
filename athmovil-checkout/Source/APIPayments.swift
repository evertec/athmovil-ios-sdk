//
//  APIPayments.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

struct APIPayments {
    
    static let api: APIClient = {
        APIClient(configuration: .defaultATHMovil(
            httpAdditionalHeaders: .athMovilHeaders)
        )
    }()

    static let apiAWS: APIClientAWS = {
        APIClientAWS(
            configuration: .defaultATHMovil(
                httpAdditionalHeaders: .athMovilHeaders
            )
        )
    }()
    
    public enum HTTPMethod: String {
        case post
        case get
        case put
        case delete
    }
}

fileprivate extension URLSessionConfiguration {
    static func defaultATHMovil(
        httpAdditionalHeaders: [AnyHashable : Any]?) -> URLSessionConfiguration {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = httpAdditionalHeaders
            configuration.waitsForConnectivity = true
            configuration.allowsCellularAccess = true
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 60
            return configuration
        }
}

fileprivate extension Dictionary where Key == AnyHashable, Value == Any {
    static var athMovilHeaders: [Key: Value] = {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let currentLanguaje = Locale.current.languageCode ?? ""
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let headers: [AnyHashable: Any] = ["Accept": "application/json",
                                           "Content-Type": "application/json",
                                           "agentType": "ios",
                                           "athm_version": currentVersion,
                                           "Accept-Language": currentLanguaje,
                                           "operatingSystem": "iOS \(UIDevice.current.systemVersion)",
                                           "manufacturer" : "Apple",
                                           "deviceID": deviceId]
        
        return headers
    }()
}
