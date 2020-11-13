//
//  ClientAppCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation


protocol ClientAppCodable: Encodable {
 
}

struct ClientAppCoder: ClientAppCodable {
    
    let clientAPP: ATHMClientApp

}

fileprivate enum CodingKeys: String, CodingKey {
    case scheme
}

extension ClientAppCoder{
    
    func encode(to encoder: Encoder) throws{
        
        do{
            try hasExceptionableProperties()
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(clientAPP.urlScheme, forKey: .scheme)
            
        }catch let exceptionPayment as ATHMPaymentError{
            let paymentException = ATHMPaymentError(message: exceptionPayment.message, source: .request)
            throw paymentException
            
        }catch let exception{
            
            let genericException = exception as NSError
            let messageError = "There was an error while encode ClientApp. Detail: \(genericException.debugDescription)"
            let paymentException = ATHMPaymentError(message: messageError,source: .request)
            throw paymentException
        }
    }
    
}

extension ClientAppCoder: Exceptionable{
    
    func hasExceptionableProperties() throws {
        
        if self.clientAPP.urlScheme.isEmpty{
            throw ATHMPaymentError(message: "The url scheme is required", source: .request)
        }
        
    }
}


