//
//  DoubleExtension.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 28/10/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

extension Double {
    
    func convertToDecimal(_ numberDecimal:Int?) -> Decimal {
        var decimalAsDouble = Decimal(abs(self))
        var resultDecimal = Decimal(0)
        NSDecimalRound(&resultDecimal, &decimalAsDouble, numberDecimal ?? 2, .bankers)
        return resultDecimal
    }
}
