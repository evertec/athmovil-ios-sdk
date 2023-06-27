//
//  ATHMPaymentSecureError.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 15/09/22.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

@objc(ATHMPaymentSecureError)
public class ATHMPaymentSecureError: NSObject, Error {
    
    enum Source {
        case request, response
    }
    
    ///Exception custom message
    var message: String
    
    ///Source of the exception it could be in request or response
    var source: ATHMPaymentSecureError.Source
    
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
    init(message: String, source: ATHMPaymentSecureError.Source) {
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
