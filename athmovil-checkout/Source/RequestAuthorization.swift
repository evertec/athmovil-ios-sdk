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
        let headers = ["Authorization":authorization,
                       "Host":TargetEnviroment.selectedEnviroment.baseUrlAWS]
        let bodyRequest = Body()
        return Request.post(baseURL: URL(string:"https://"+TargetEnviroment.selectedEnviroment.baseUrlAWS)!,
                            path: "/api/business-transaction/ecommerce/authorization",
                            body: bodyRequest, headers: headers) { result in
            
            switch result {
                case .success:
                    result.decoding(AuthorizationResponseCodable.self) { resultDecoding in
                        completion(map(resultDecoding))
                    }
                case .failure:
                let netWorkError = ATHMAuthorizationResponse(status: ATHMAuthorizationResponse.TypeStatus.success,message: "Sorry for the inconvenience. Please try again later.")
                completion(.failure(netWorkError))
            }
        }
    }
    
    private static func map(_ result: Result<AuthorizationResponseCodable, NetworkError>) -> Result<AuthorizationResponseCodable, ATHMAuthorizationResponse> {
        
        switch result {
            case .success(let respondeData):
            if(respondeData.status == ATHMAuthorizationResponse.TypeStatus.success){
                    return .success(respondeData)
                }else{
                    let netWorkError = ATHMAuthorizationResponse(status:ATHMAuthorizationResponse.TypeStatus.error,message: "Sorry for the inconvenience. Please try again later.")
                    return .failure(netWorkError)
                }                
            case .failure:
            let netWorkError = ATHMAuthorizationResponse(status:ATHMAuthorizationResponse.TypeStatus.error,message: "Sorry for the inconvenience. Please try again later.")
                return .failure(netWorkError)
        }
        
    }
}
