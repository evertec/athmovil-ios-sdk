//
//  CustomerCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol CustomerCodable: Decodable {

}


struct CustomerCoder: CustomerCodable {
    
    let customer: ATHMCustomer
}

fileprivate enum CodingKeys: String, CodingKey{
    case name, phoneNumber, email
}

extension CustomerCoder: Decodable{
    
    init(from decoder: Decoder) throws{
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let name: String = container.decodeValueDefault(forKey: .name)
            let phoneNumber: String =  container.decodeValueDefault(forKey: .phoneNumber)
            let email: String = container.decodeValueDefault(forKey: .email)
            
            customer = ATHMCustomer(name: name, phoneNumber: phoneNumber, email: email)
            
        }catch let exception as NSError{
            let message = exception.debugDescription
            let castException = ATHMPaymentError(message: "There was an error while decode Customer. Detail: \(message)",
                                                 source: .response)
            throw castException
        }
    }
}


