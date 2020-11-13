//
//  URLOpener.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 2/22/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import Foundation

public protocol URLOpenerProtocol {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

struct URLOpener {
    private let application: URLOpenerProtocol
    
    init(application: URLOpenerProtocol) {
        self.application = application
    }

    /**
     Opens a scheme with the provided URL
     
      - Parameters:
        - url: url that will be opened
        - completion: called after opening is completed param is true if the scheme was opened successfully param is false if opening failed
     */
    func openWebsite(url: URL, alternateURL: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any],
                     completion: ((Bool) -> Void)?) {
        application.open(url, options: options) {  (success) in
            if success {
                completion?(success)
            } else {
                self.application.open(alternateURL, options: [:], completionHandler: nil)
            }
        }
    }
}

extension UIApplication: URLOpenerProtocol { }

protocol URLOpenerAdaptable {
    
    /**
     Opens a scheme with the provided URL
     
      - Parameters:
        - url: url that will be opened
        - completion: called after opening is completed param is true if the scheme was opened successfully param is false if opening failed
     */
    func openWebsite(url: URL, alternateURL: URL,
                     options: [UIApplication.OpenExternalURLOptionsKey : Any],
                     completion: ((Bool) -> Void)?)
}


extension URLOpener: URLOpenerAdaptable{}
