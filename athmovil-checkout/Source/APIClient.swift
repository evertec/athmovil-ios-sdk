//
//  APIClient.swift
//  athmovil-checkout
//
//  Created by Hansy on 12/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol APIClientRequestable {
    func send(request: Request)
}

class APIClient: NSObject, URLSessionDelegate {
    
    enum Method: String {
        case post
        case get
    }
    
    private let configuration: URLSessionConfiguration
    private lazy var session: URLSession = {
        URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
    }()
    private let dispatchQueue = DispatchQueue(label: "com.evertecinc.athmovilCheckout.NetworkRequest",
                                              qos: .userInitiated,
                                              attributes: .concurrent)
        
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    func send(request: Request) {
        
        dispatchQueue.async {
            let urlRequest = request.builder.toURLRequest()
            
            let task = self.session.dataTask(with: urlRequest) { (data, URLresponse, error) in
                
                var result: Result<Data, NetworkError>
                
                if error != nil {
                    result = .failure(NetworkError.netWorkError)
                } else if let apiError = NetworkError.error(from: URLresponse) {
                    result = .failure(apiError)
                } else {
                    result = .success(data ?? Data())
                }
                    
                request.completion(result)
            }
            
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            disposition = URLSession.AuthChallengeDisposition.useCredential
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .cancelAuthenticationChallenge
            } else {
                credential = session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                if credential != nil {
                    disposition = .useCredential
                }
            }
        }
        completionHandler(disposition, credential)
    }
}

extension APIClient: APIClientRequestable {}

struct APIClientSimulated: APIClientRequestable {
    let paymentRequest: PaymentRequestable
    func send(request: Request) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            let client = ATHMCustomer(name: "Valeria Herrero", phoneNumber: "(787) 123-4567", email: "email@example.com")
            let status = ATHMPaymentStatus(reference: "000000-00000000abcd", dayliId: 1, date: Date(), status: .completed)
            paymentRequest.payment.fee = NSNumber(value: (paymentRequest.payment.total.doubleValue * 0.0225).rounded())
            paymentRequest.payment.netAmount = NSNumber(value: paymentRequest.payment.total.doubleValue - paymentRequest.payment.fee.doubleValue)
            
            let response = PaymentResponseCoder(payment: paymentRequest.payment, customer: client, status: status)
            let dataDummy = try? PaymentResponseCoder.encoder.encode(response)
            
            request.completion(.success(dataDummy!))
        }
    }
}
