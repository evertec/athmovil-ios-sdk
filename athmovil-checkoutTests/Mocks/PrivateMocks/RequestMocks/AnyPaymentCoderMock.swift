//
//  AnyPaymentCoderMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/4/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct AnyPaymentCoderMock: PaymentRequestCodable {
    
    var businessAccount: BusinessAccountCoderMock
    var scheme: URLSchemeCoderMock
    var payment: PaymentCoderMock
    var timeout: TimeInterval = 600.0
    var version: ATHMVersion = .three

}

