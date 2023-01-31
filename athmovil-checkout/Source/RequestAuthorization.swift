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
        
        let authorization = "Bearer \(UserPreferences.shared.authToken)"
        let headers = ["Authorization":authorization,
                       "Host":"ozm9fx7yw5.execute-api.us-east-1.amazonaws.com"]
        let bodyRequest = Body()
        return Request.post(baseURL: URL(string: "https://vpce-04edaf73e4e83adea-flbxnqbx.execute-api.us-east-1.vpce.amazonaws.com")!,
                            path: "/api/business-transaction/ecommerce/authorization",
                            body: bodyRequest, headers: headers) { result in
            
            switch result {
                case .success:
                    result.decoding(AuthorizationResponseCodable.self) { resultDecoding in
                        completion(map(resultDecoding))
                    }
                case .failure:
                let netWorkError = ATHMAuthorizationResponse(status: ATHMAuthorizationResponse.TypeStatus.success,message: "Error getting the response from the webservice")
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
                    let netWorkError = ATHMAuthorizationResponse(status:ATHMAuthorizationResponse.TypeStatus.error,message: "Error getting the response from the webservice")
                    return .failure(netWorkError)
                }                
            case .failure:
            let netWorkError = ATHMAuthorizationResponse(status:ATHMAuthorizationResponse.TypeStatus.error,message: "Error getting the response from the webservice")
                return .failure(netWorkError)
        }
        
    }
}
