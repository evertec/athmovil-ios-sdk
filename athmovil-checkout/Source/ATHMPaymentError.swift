//
//  ATHMPaymentError.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol Exceptionable {
       
    /// Check it the current object has valid properties, it should return a exception if the object is not valid
    func hasExceptionableProperties() throws
}

@objc(ATHMPaymentError)
public class ATHMPaymentError: NSObject, Error {
    
    enum Source {
        case request, response
    }
    
    ///Exception custom message
    var message: String
    
    ///Source of the exception it could be in request or response
    var source: ATHMPaymentError.Source
    
    /// A localized message describing the reason for the failure.
    @objc public var failureReason: String { message }
    
    /// Error's description in request or response
    @objc public var errorDescription: String { "Error in \(source)" }
    
    /// If the error is in the request will be true otherwise will be false
    @objc public var isRequestError: Bool { return source == .request }
    
    /// Mesage to return in the exception
    /// - Parameters:
    ///   - message: Message to return to user in the exception
    ///   - source: Source of the exception it could be request or response
    init(message: String, source: ATHMPaymentError.Source) {
        self.message = message
        self.source = source
    }
    
    public override var description: String {
        """
        ATHMPaymentError:
            - description: \(errorDescription)
            - failureReason: \(failureReason)
        """
    }
    
}
