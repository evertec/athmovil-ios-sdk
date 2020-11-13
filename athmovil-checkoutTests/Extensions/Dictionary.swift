//
//  Dictionary.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


extension Dictionary {
    public var toJSONString: String? {

        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            else { return nil }

        let jsonString = String(data: data, encoding: String.Encoding.utf8)

        return jsonString
    }
}
