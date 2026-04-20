//
//  RequestPayment.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 13/09/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

extension Request {
        
    static func payment(
        currentPayment: PaymentSecureRequestable,
        completion: @escaping (Result<PaymentSecureResponseCodable, ATHMPaymentError>) -> Void
    ) -> Request {
        
        let headers = ["Host":TargetEnviroment.selectedEnviroment.baseUrlAWS]
        let url = URL(string:"https://"+TargetEnviroment.selectedEnviroment.baseUrlAWS)!
        return Request.post(baseURL:url,
                            path: "/api/business-transaction/ecommerce/payment",
                            body: currentPayment.paymentRequest, headers: headers) { result in
            
            switch result {
                case .success(let data):
                    #if DEBUG
                        print("Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data")")
                    #endif
                    do {
                        let decoded = try JSONDecoder().decode(PaymentSecureResponseCodable.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        let netWorkError = ATHMPaymentError(message: "Decoding failed: \(error.localizedDescription)", source: .response)
                        completion(.failure(netWorkError))
                    }
                case .failure(let error):
                    let netWorkError = ATHMPaymentError(
                        message: "Sorry for the inconvenience. Please try again later.",
                        source: .response,
                        debugError: "Error Server \(dump(error))"
                    )
                    completion(.failure(netWorkError))
            }
        }
    }
    
    private static func map(_ result: Result<PaymentSecureResponseCodable, Error>,
                            currentPayment: PaymentSecureRequestable) -> Result<PaymentSecureResponseCodable, ATHMPaymentError> {
        switch result {
            case .success(let respondeData):
                if(respondeData.status == "success") {
                    return .success(respondeData)
                } else {
                    let netWorkError = ATHMPaymentError(
                        message: "Sorry for the inconvenience. Please try again later.",
                        source: .response,
                        debugError: "Error Response data \(dump(respondeData))"
                    )
                    return .failure(netWorkError)
                }
            case .failure(let error):
                let netWorkError = ATHMPaymentError(
                    message: "Sorry for the inconvenience. Please try again later.",
                    source: .response,
                    debugError: "Error Map data \(dump(error))"
                )
                return .failure(netWorkError)
        }
        
    }
}
