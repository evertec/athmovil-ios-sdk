//
//  EnviromentMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct EnviromentMock<P>: PaymentEnviromentRepresentable where P:PaymentRequestCodable{
        
    ///URL of the ath movil
    var athMovilAppURL: String
    
    var payment: P
    
    init(payment: P, athMovilURL: String)  {
        self.payment = payment
        self.athMovilAppURL = athMovilURL
    }
    

}
