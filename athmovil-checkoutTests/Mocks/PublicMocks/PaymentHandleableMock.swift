//
//  PaymentHandleableMock.swift
//  athmovil-checkoutTests
//
//  Created by Hansy on 12/4/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
@testable import athmovil_checkout

struct PaymentHandleableMock: PaymentHandleable {
    
    /// Unique identifier per request
    var traceId: UUID = UUID()
    
    ///it is going to call when the there is error in the request or in the response from ATH Movil
    var onException: (ATHMPaymentError) -> Void
    
    ///it is going to call when the there is error in the request or in the response from ATH Movil
    let onCompleted: ((ATHMPaymentResponse) -> Void)?
    
    ///it is going to call when the there is error in the request or in the response from ATH Movil
    let onCompletedData: ((Data) -> Void)?
    
    /// Method to confirm the payment to ATH Movil
    /// - Parameter data: data form the url it must containts the required properties otherwise will call onexception closure
    func completeFrom(data: Data) {
        onCompletedData?(data)
    }
    
    /// Method to complete the transaction after the web service response with a transaction
    /// - Parameter serverPayment: current response of the web service ATHMPaymentHandler and ATHMPaymentHandlerDictionary implements this method in differente way
    func completeFrom(serverPayment: ATHMPaymentResponse) {
        onCompleted?(serverPayment)
    }
}

extension PaymentHandleableMock {
    
    init(onCompleted: @escaping (ATHMPaymentResponse) -> Void) {
        self.onCompleted = onCompleted
        self.onCompletedData = nil
        self.onException = { _ in }
    }
}

extension PaymentHandleableMock {
    
    init(onCompletedData: @escaping (Data) -> Void) {
        self.onCompletedData = onCompletedData
        self.onCompleted = nil
        self.onException = { _ in }
    }
}


extension PaymentHandleableMock {
    
    init(onException: @escaping (ATHMPaymentError) -> Void) {
        self.onException = onException
        self.onCompleted = nil
        self.onCompletedData = nil
    }
}
