//
//  RequestPayment.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 13/09/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

extension Request {
        
    static func payment(currentPayment: PaymentSecureRequestable,
                       completion: @escaping (Result<PaymentSecureResponseCodable, ATHMPaymentError>) -> Void) -> Request {
        
        let headers = ["Host":"ozm9fx7yw5.execute-api.us-east-1.amazonaws.com"]
        return Request.post(baseURL: URL(string: "https://vpce-04edaf73e4e83adea-flbxnqbx.execute-api.us-east-1.vpce.amazonaws.com")!,
                            path: "/api/business-transaction/ecommerce/payment",
                            body: currentPayment.paymentRequest, headers: headers) { result in
            
            switch result {
                case .success:
                    result.decoding(PaymentSecureResponseCodable.self) { resultDecoding in
                        completion(map(resultDecoding, currentPayment: currentPayment))
                    }
                case .failure:
                let netWorkError = ATHMPaymentError(message: "Error getting the response from the webservice",
                                                source: .response)
                completion(.failure(netWorkError))
            }
        }
    }
    
    private static func map(_ result: Result<PaymentSecureResponseCodable, NetworkError>,
                            currentPayment: PaymentSecureRequestable) -> Result<PaymentSecureResponseCodable, ATHMPaymentError> {
        
        switch result {
            case .success(let respondeData):
                if(respondeData.status == "success"){
                    return .success(respondeData)
                }else{
                    let netWorkError = ATHMPaymentError(message: "Error getting the response from the webservice",
                                                        source: .response)
                    return .failure(netWorkError)
                }                
            case .failure:
                
                let netWorkError = ATHMPaymentError(message: "Error getting the response from the webservice",
                                                    source: .response)
                return .failure(netWorkError)
        }
        
    }
}
