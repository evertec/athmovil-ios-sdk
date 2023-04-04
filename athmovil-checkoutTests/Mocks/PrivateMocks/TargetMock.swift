//
//  EnviromentMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy Enrique on 8/3/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct TargetMock<P>: TargetURLRepresentable where P: Encodable {
        
    ///URL of the ath movil
    let athMovilAppURL: String
    let payment: P
    let enviroment: TargetEnviroment = .production
    
    init(payment: P, athMovilURL: String)  {
        self.payment = payment
        self.athMovilAppURL = athMovilURL
    }

}
