//
//  PaymentSecureRequestMock.swift
//  athmovil-checkoutTests
//
//  Created by Ismael Paredes on 13/02/23.
//  Copyright © 2023 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct PaymentSecureRequestMock: PaymentSecureRequestable {
    
    var payment = ATHMSecurePayment()
    var paymentRequest = ATHMSendPayment(total: 20)
    var paymentOld = ATHMPayment(total: 20)
    var businessAccount = ATHMBusinessAccount(token: "TokenDefault")
    var scheme = ATHMURLScheme(urlScheme: "DefaultURLScheme")
    var timeout = TimeInterval(6000)
    var version: ATHMVersion = .three
}


extension PaymentSecureRequestMock: PaymentSecureRequestCodable {
    
    enum CodingKeys: CodingKey {
        case businessAccount, scheme, payment, paymentOld, timeout
    }
}
