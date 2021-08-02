//
//  ResultExtension.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

extension Result where Success == Data, Failure == NetworkError {
    
    func decoding<M: Model>(_ model: M.Type, completion: @escaping(Result<M, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            
            let result = self.flatMap { data -> Result<M, NetworkError> in
                
                do {
                    let modelDecode = try M.decoder.decode(M.self, from: data)
                    
                    return .success(modelDecode)
                    
                } catch let exceptionDecoding as DecodingError {
                    return .failure(.decodingError(exceptionDecoding))
                } catch {
                    return .failure(.unHandledResponse)
                }
            }
            completion(result)
        }
    }
}
