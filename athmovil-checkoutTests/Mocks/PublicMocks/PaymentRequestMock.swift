//
//  PaymentRequestMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct PaymentRequestMock: PaymentRequestable {
    /// Business account if the token account it is empty you will received an exception
    var businessAccount = ATHMBusinessAccount(token: "TokenDefault")
    /// Current application that will send the request to ATH Móvil Personal
    var scheme = ATHMURLScheme(urlScheme: "DefaultURLScheme")
    /// Purchase representation to send to ATH Movil
    var payment = ATHMPayment(total: 20)
    /// Purchase Timeout in ath movil personal
    var timeout = TimeInterval(6000)
    var version: ATHMVersion = .three
}


extension PaymentRequestMock: PaymentRequestCodable {
    
    enum CodingKeys: CodingKey {
        case businessAccount, scheme, payment, timeout
    }
}
