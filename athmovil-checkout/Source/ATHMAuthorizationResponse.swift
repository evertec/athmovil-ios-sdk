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

    
    required init(status: ATHMAuthorizationResponse.TypeStatus, message: String) {
        self.status = status
        self.message = message
    }
}

extension ATHMAuthorizationResponse{
    public enum TypeStatus: String, Codable {
        case success
        case error
    }
}
