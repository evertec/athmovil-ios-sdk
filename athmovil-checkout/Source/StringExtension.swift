//
//  StringExtension.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

extension String {
    
    public static let telephoneNumberLength = 10
        
    /**
     Clear the string with all the characters different to number
     - Parameter movingMoreNumbers: true if the length string is more than 10, example 12345678912 in this case
     will return 1234567891
     Returns a string only with numbers
     */
    func clearAsNumber(movingMoreNumbers: Bool = true) -> String{
        
        
        let lengthToValidate = String.telephoneNumberLength
        
        let regexp = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let rangeString = NSRange(location: 0, length: self.count)
        
        var clearString = regexp?.stringByReplacingMatches(in: self,
                                                           options: NSRegularExpression.MatchingOptions.init(rawValue: 0),
                                                           range: rangeString, withTemplate: "") ?? ""
        
        if clearString.count > lengthToValidate && movingMoreNumbers{
            
            let amountOfCharactersToRemove = clearString.count - lengthToValidate
            let startIndex = clearString.index(clearString.startIndex, offsetBy: amountOfCharactersToRemove)
            clearString = String(clearString[startIndex...])
        }
        
        return clearString
    }
    
    var containsSpecialChars: Bool {
        let pattern = ".*[^\\sA-Za-z0-9].*"
        let regex = NSRegularExpression(pattern)
        return regex.matches(self)
    }
}
