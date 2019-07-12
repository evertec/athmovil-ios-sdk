//
//  URLOpenerProtocol.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 2/22/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import Foundation

/// MARK: - URLOpenerProtocol

protocol URLOpenerProtocol {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: URLOpenerProtocol { }
