//
//  NSNumber.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/31/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


extension NSNumber{
    
    /**
     Method to validate if the current value is greter or igual than zero, no negative o infinite number in this case will return true otherwise false
     */
    var isUnexpectedAmount: Bool{
        
        let doubleValue = self.doubleValue
        
        return doubleValue.isNaN || doubleValue.isInfinite || doubleValue <= 0
        
    }
}
