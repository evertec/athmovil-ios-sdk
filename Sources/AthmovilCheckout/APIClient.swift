//
//  APIClient.swift
//  athmovil-checkout
//
//  Created by Hansy on 12/2/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoKit

protocol APIClientRequestable {
    var session: URLSession { get }
    var dispatchQueue: DispatchQueue { get }
    func send(request: Request)
}

extension APIClientRequestable {
    func send(request: Request) {
        
        dispatchQueue.async {
            let urlRequest = request.builder.toURLRequest()
            
            let task = self.session.dataTask(with: urlRequest) { (data, URLresponse, error) in
                
                var result: Result<Data, Error>
                
                if let responseError = error {
                    result = .failure(responseError)
                } else if let apiError = NetworkError.error(from: URLresponse) {
                    if let data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        result = .failure(
                            NSError(
                                domain: "Error Server",
                                code: -2005,
                                userInfo: [NSDebugDescriptionErrorKey: "\(apiError) \(errorMessage)"]
                            )
                        )
                    } else {
                        result = .failure(apiError)
                    }
                } else {
                    result = .success(data ?? Data())
                }
                
                request.completion(result)
            }
            
            task.resume()
        }
    }
}

class APIClient: NSObject, APIClientRequestable {
    
    enum Method: String {
        case post
        case get
    }
    
    private let configuration: URLSessionConfiguration
    internal lazy var session: URLSession = { URLSession(configuration: configuration) }()
    internal let dispatchQueue = DispatchQueue(
        label: "com.evertecinc.athmovilCheckout.NetworkRequest",
        qos: .background,
        attributes: .concurrent
    )
        
    init(
        configuration: URLSessionConfiguration
    ) {
        self.configuration = configuration
    }
    
}

class APIClientAWS: NSObject, URLSessionDelegate, APIClientRequestable {
        
    private let configuration: URLSessionConfiguration
    
    internal lazy var session: URLSession = {
        URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: OperationQueue()
        )
    }()
    
    internal let dispatchQueue = DispatchQueue(
        label: "com.evertecinc.athmovilAWSCheckout.NetworkRequest",
        qos: .background,
        attributes: .concurrent
    )
    
    init(
        configuration: URLSessionConfiguration
    ) {
        self.configuration = configuration
    }
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        
        guard TargetEnviroment.trustedDomains.contains(challenge.protectionSpace.host),
              let serverTrust = challenge.protectionSpace.serverTrust,
              serverTrust.evaluate() else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        switch challenge.protectionSpace.authenticationMethod {
            case NSURLAuthenticationMethodServerTrust where challenge.protectionSpace.serverTrust != nil:
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
            default:
                completionHandler(.performDefaultHandling, nil)
        }
    }
}

struct APIClientSimulated: APIClientRequestable {
    let session: URLSession = URLSession.shared
    let dispatchQueue = DispatchQueue(label: "")
    let paymentRequest: PaymentRequestable
    
    func send(request: Request) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            let client = ATHMCustomer(
                name: "Valeria Herrero",
                phoneNumber: "(787) 123-4567",
                email: "email@example.com"
            )
            let status = ATHMPaymentStatus(
                reference: "000000-00000000abcd",
                dayliId: 1,
                date: Date(),
                status: .completed
            )
        
            paymentRequest.payment.fee = NSNumber(value: (paymentRequest.payment.total.doubleValue * 0.0225).rounded())
            paymentRequest.payment.netAmount = NSNumber(
                value: paymentRequest.payment.total.doubleValue - paymentRequest.payment.fee.doubleValue
            )
            
            let response = PaymentResponseCoder(
                payment: paymentRequest.payment,
                customer: client,
                status: status
            )
            let dataDummy = try? PaymentResponseCoder.encoder.encode(response)
            request.completion(.success(dataDummy!))
        }
    }
}

fileprivate extension SecTrust {
    func evaluate() -> Bool {
        var trustError: CFError?
        let evaluatedSuccess = SecTrustEvaluateWithError(self, &trustError)
        return evaluatedSuccess && trustError == nil
    }
}
