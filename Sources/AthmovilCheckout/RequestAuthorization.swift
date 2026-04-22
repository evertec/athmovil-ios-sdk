//
//  RequestPayment.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 19/09/22.
//  Copyright © 2022 Evertec. All rights reserved.
//

import Foundation

extension Request {
        
    private struct Body: Model {}
    
    static func authorization(completion: @escaping (Result<AuthorizationResponseCodable, ATHMAuthorizationResponse>) -> Void) -> Request {
        let token = KeychainHelper.standard.read(service: "authToken",type: String.self) ?? ""
        let authorization = "Bearer \(String(describing: token))"
        let headers = ["Authorization":authorization]
        let bodyRequest = Body()
        let urlService = "/api/business-transaction/ecommerce/authorization"
        
        #if DEBUG
            print("Request URL: \("https://"+TargetEnviroment.selectedEnviroment.baseUrlAWS)\(urlService)")
            print("Request Headers: \(headers)")
            print("Request Body: \(bodyRequest)")
        #endif
        
        return Request.post(
            baseURL: URL(string:"https://"+TargetEnviroment.selectedEnviroment.baseUrlAWS)!,
            path: urlService,
            body: bodyRequest,
            headers: headers
        ) { result in
            
            switch result {
                case .success:
                
                    result.decoding(AuthorizationResponseCodable.self) { resultDecoding in
                        #if DEBUG
                            print("Response: \(result)")
                        #endif
                        completion(map(resultDecoding))
                    }
                case .failure(let error):
                    #if DEBUG
                        print("Response error: \(error)")
                    #endif
                    let netWorkError = ATHMAuthorizationResponse(
                        status: ATHMAuthorizationResponse.TypeStatus.success,
                        message: "Sorry for the inconvenience. Please try again later.",
                        debugError: "Error Server: \(dump(error)))"
                    )
                    completion(.failure(netWorkError))
            }
        }
    }
    
    private static func map(
        _ result: Result<AuthorizationResponseCodable, Error>
    ) -> Result<AuthorizationResponseCodable, ATHMAuthorizationResponse> {
        
        switch result {
            case .success(let respondeData):
                if(respondeData.status == .success) {
                    return .success(respondeData)
                } else {
                    let netWorkError = ATHMAuthorizationResponse(
                        status:ATHMAuthorizationResponse.TypeStatus.error,
                        message: "Sorry for the inconvenience. Please try again later.",
                        debugError: "Error Status Authorized response: \(dump(respondeData))"
                    )
                    return .failure(netWorkError)
                }
            case .failure(let error):
                let netWorkError = ATHMAuthorizationResponse(
                    status:ATHMAuthorizationResponse.TypeStatus.error,
                    message: "Sorry for the inconvenience. Please try again later.",
                    debugError: "Error Map Server : \(dump(error))"
                )
                return .failure(netWorkError)
        }
    }
}
