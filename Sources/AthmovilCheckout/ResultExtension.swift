//
//  ResultExtension.swift
//  athmovil-checkout
//
//  Created by Hansy on 2/4/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation

extension Result where Success == Data, Failure == any Error {
    
    func decoding<M: Model>(
        _ model: M.Type,
        completion: @escaping(Result<M, Failure>) -> Void
    ) {
        DispatchQueue.global().async {
            
            let result = self.flatMap { data -> Result<M, Failure> in
                do {
                    return .success(try M.decoder.decode(M.self, from: data))
                } catch let error {
                    return .failure(error)
                }
            }
            completion(result)
        }
    }
}
