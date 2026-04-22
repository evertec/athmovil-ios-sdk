//
//  CustomerCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol CustomerCodable: Codable { }

extension ATHMCustomer: CustomerCodable {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case name, phoneNumber, email
    }
}

extension ATHMCustomer: Decodable {

    convenience public init(from decoder: Decoder) throws {

        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let name: String = container.decodeValueDefault(forKey: .name)
            let phoneNumber: String = container.decodeValueDefault(forKey: .phoneNumber)
            let email: String = container.decodeValueDefault(forKey: .email)

            self.init(name: name, phoneNumber: phoneNumber, email: email)

        } catch {
            let castException = ATHMPaymentError(message: "Sorry for the inconvenience. Please try again later.",
                                                 source: .response)
            throw castException
        }
    }
}

extension ATHMCustomer: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(email, forKey: .email)
        try? container.encodeIfPresent(name, forKey: .name)
        try? container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
    }
}
