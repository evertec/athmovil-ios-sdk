//
//  NSNumber.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/31/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

extension NSNumber {
    
    /// Method to validate if the current value is less than or equal to one (minimum amount to transfer),  negative or infinite number;
    /// in that case will return true otherwise false
    var isUnexpectedAmount: Bool {
        
        let doubleValue = self.doubleValue
        
        return doubleValue.isNaN || doubleValue.isInfinite || doubleValue < 1
        
    }
}
