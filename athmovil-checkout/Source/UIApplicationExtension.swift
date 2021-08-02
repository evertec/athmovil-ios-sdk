//
//  UIApplicationExtension.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/26/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

protocol URLOpenerAdaptable {
    
    /// Opens a scheme with the provided URL
    /// - Parameters:
    ///   - url: url that will be opened
    ///   - alternateURL: alternative URL when the url parameter can not be opened
    ///   - options: options for openning the url
    ///   - completion: closure to call after the URL have been opened
    func open(url: URL,
              alternateURL: URL,
              options: [UIApplication.OpenExternalURLOptionsKey : Any],
              completion: ((Bool) -> Void)?)
}

extension UIApplication: URLOpenerAdaptable {
    
    /// Opens a scheme with the provided URL
    /// - Parameters:
    ///   - url: url that will be opened
    ///   - alternateURL: alternative URL when the url parameter can not be opened
    ///   - options: options for openning the url
    ///   - completion: closure to call after the URL have been opened
    func open(url: URL,
              alternateURL: URL,
              options: [UIApplication.OpenExternalURLOptionsKey : Any],
              completion: ((Bool) -> Void)?) {
        
        DispatchQueue.main.async {
            self.open(url, options: options) {  success in
                if success {
                    completion?(success)
                } else {
                    self.open(alternateURL, options: [:]) { success in
                        completion?(success)
                    }
                }
            }
        }
        
    }
}
