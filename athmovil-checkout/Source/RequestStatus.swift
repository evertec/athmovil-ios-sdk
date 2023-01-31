//
//  RequestStatus.swift
//  athmovil-checkout
//
//  Created by Hansy on 12/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

extension Request {
    
    private struct Body: Model {
        let publicToken: String
        let paymentID: String
    }
    
    static func status(paymentId: String,
                       currentPayment: PaymentRequestable,
                       completion: @escaping (Result<ATHMPaymentResponse, ATHMPaymentError>) -> Void) -> Request {
            
        let bodyRequest = Body(publicToken: currentPayment.businessAccount.token, paymentID: paymentId)
        
        return Request.post(baseURL: TargetEnviroment.selectedEnviroment.baseURL,
                            path: "eCommerceTransfer/consultTransactionStatus",
                            body: bodyRequest) { result in
            
            switch result {
                case .success:
                    
                    result.decoding(PaymentServiceCoder.self) { resultDecoding in
                        
                        completion(map(resultDecoding, currentPayment: currentPayment))
                    }
                
                case .failure:
                    let netWorkError = ATHMPaymentError(message: "Error getting the response from the webservice",
                                                        source: .response)
                    completion(.failure(netWorkError))
            }
        }
    }
    
    private static func map(_ result: Result<PaymentServiceCoder, NetworkError>,
                            currentPayment: PaymentRequestable) -> Result<ATHMPaymentResponse, ATHMPaymentError> {
        
        switch result {
            case .success(let respondeCoder):
                
                let response = ATHMPaymentResponse(payment: respondeCoder.payment,
                                                   status: respondeCoder.status,
                                                   customer: respondeCoder.customer)
                
                return .success(response)
                
            case .failure:
                let statusDefault = ATHMPaymentStatus(status: .cancelled)
                
                let paymentCancelled = ATHMPaymentResponse(payment: currentPayment.payment,
                                                           status: statusDefault,
                                                           customer: "")
                return .success(paymentCancelled)
        }
        
    }
}

private struct PaymentServiceCoder: Model {
    let customer: ATHMCustomer
    let payment: ATHMPayment
    let status: ATHMPaymentStatus
    
    init(from decoder: Decoder) throws {
        do {
            
            customer = try ATHMCustomer(from: decoder)
            payment = try ATHMPayment(from: decoder)
            
            let container = try decoder.container(keyedBy: ATHMPaymentStatus.CodingKeys.self)
            let paymentStatus: ATHMStatus = container.decodeValueDefault(forKey: .status)
            let dayliId: Int = container.decodeValueDefault(forKey: .dailyTransactionID)
            let reference: String = container.decodeValueDefault(forKey: .referenceNumber)
            let date: Date = container.decodeValueDefault(forKey: .date)
            
            self.status = ATHMPaymentStatus(reference: reference,
                                            dayliId: abs(dayliId),
                                            date: date,
                                            status: paymentStatus)
            
        } catch let exception {
            throw exception
        }
    }
}
