//
//  ATHMAuthorizationResponse.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 10/09/22.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

final public class ATHMAuthorizationResponse: NSObject, Error {
        
    public let status: ATHMAuthorizationResponse.TypeStatus
    public let message: String
    public let debugError: String
    
    public override var debugDescription: String {
        debugError
    }
    
    required init(
        status: ATHMAuthorizationResponse.TypeStatus,
        message: String,
        debugError: String
    ) {
        self.status = status
        self.message = message
        self.debugError = debugError
    }
}

extension ATHMAuthorizationResponse {
    public enum TypeStatus: String, Codable {
        case success
        case error
    }
}
