//
//  AMCheckoutDelegateSpy.swift
//  athm-checkoutTests
//
//  Created by Leonardo Maldonado on 2/21/19.
//  Copyright © 2019 Evertec, Inc. All rights reserved.
//

import Foundation

@testable import athm_checkout

class AMCheckoutDelegateSpy: NSObject, AMCheckoutDelegate {
    
    var onCompletedPaymentWasCalled: Bool = false
    var onCancelledPaymentWasCalled: Bool = false
    var onExpiredPaymentWasCalled: Bool = false

    func onCompletedPayment(
        referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        self.onCompletedPaymentWasCalled = true
    }
    
    func onCancelledPayment(
        referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        self.onCancelledPaymentWasCalled = true
    }
    
    func onExpiredPayment(
        referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        self.onExpiredPaymentWasCalled = true
    }
}
