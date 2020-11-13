//
//  BusinessAccountMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct BusinessAccountCoderMock: BusinessAccountCodable {
    
    let businessTest: String
}

struct ExceptionCoderMock: BusinessAccountCodable {
    
    
    func encode(to encoder: Encoder) throws{
        
        let messageError = "This is a mock"
        let paymentException = ATHMPaymentError(message: messageError,source: .request)
        throw paymentException
        
    }
    
}
