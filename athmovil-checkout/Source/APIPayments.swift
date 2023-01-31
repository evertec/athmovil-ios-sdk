//
//  APIPayments.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

struct APIPayments {
    
    static let defaultHeaders: [AnyHashable: Any] = {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let currentLanguaje = Locale.current.languageCode ?? ""
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let headers: [AnyHashable: Any] = ["Accept": "application/json",
                                           "Content-Type": "application/json",
                                           "agentType": "ios",
                                           "athm_version": currentVersion,
                                           "Accept-Language": currentLanguaje,
                                           "operatingSystem": "iOS \(UIDevice.current.systemVersion)",
                                           "Content-Encoding": "gzip",
                                           "manufacturer" : "Apple",
                                           "deviceID": deviceId]
        
        return headers
    }()
    
    static let customHeaders: [AnyHashable: Any] = {
        
        let headers: [AnyHashable: Any] = ["Accept": "application/json",
                                           "Content-Type": "application/json"]
        
        return headers
    }()
    
    static let api: APIClient = {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Self.defaultHeaders
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        return APIClient(configuration: configuration)
    }()
    
    static let apiQuality: APIClientQuality = {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Self.defaultHeaders
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        return APIClientQuality(configuration: configuration)
    }()
    
    static let apiCustom: APIClientQuality = {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Self.customHeaders
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        return APIClientQuality(configuration: configuration)
    }()
    
    public enum HTTPMethod: String {
        case post
        case get
        case put
        case delete
    }
}
