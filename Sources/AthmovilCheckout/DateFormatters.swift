//
//  DateFormatters.swift
//  athmovil-checkout
//
//  Created by Hansy on 12/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

enum DateFormatters {
    /// Format for codable objects
    static let codable: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Puerto_Rico")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.S"
        
        return dateFormatter
    }()
}
