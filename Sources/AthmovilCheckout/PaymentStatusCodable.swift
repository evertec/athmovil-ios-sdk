//
//  PaymentStatusCodable.swift
//  athmovil-checkout
//
//  Created by Hansy Enrique on 7/30/20.
//  Copyright © 2020 Evertec. All rights reserved.
//

import Foundation

protocol PaymentStatusCodable: Codable { }

extension ATHMPaymentStatus: PaymentStatusCodable {
    
    enum CodingKeys: String, CodingKey {
        case version, status, date, referenceNumber, dailyTransactionID
    }
}

extension ATHMPaymentStatus {
    
    convenience public init(from decoder: Decoder) throws {
        
        do {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let versionResponse: ATHMVersion? = try? container.decodeIfPresent(ATHMVersion.self, forKey: .version) ?? nil
            
            let date: Date = container.decodeValueDefault(forKey: .date)
            
            switch versionResponse {
                case nil:
                
                    let previousResponse = try ATHMResponseDeprecated(from: decoder)
                    let dayliId = previousResponse.dailyTransactionId?.clearAsNumber() ?? "0"
                    let numberDayliId = Int(dayliId) ?? 0
                    
                    self.init(reference: previousResponse.transactionReference ?? "",
                              dayliId: numberDayliId,
                              date: date,
                              status: previousResponse.convertToCurrentStatus())
                
                default:
                
                    let status: ATHMStatus = container.decodeValueDefault(forKey: .status)
                    let dayliId: Int = container.decodeValueDefault(forKey: .dailyTransactionID)
                    let reference: String = container.decodeValueDefault(forKey: .referenceNumber)
                                    
                    self.init(reference: reference, dayliId: abs(dayliId), date: date, status: status)
            }
            
            self.version = versionResponse
        
        } catch {
            let castException = ATHMPaymentError(message: "Sorry for the inconvenience. Please try again later.",
                                                 source: .response)
            throw castException
        }

    }
}

extension ATHMPaymentStatus: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encodeIfPresent(referenceNumber, forKey: .referenceNumber)
        try? container.encodeIfPresent(status, forKey: .status)
        try? container.encodeIfPresent(date, forKey: .date)
        try? container.encodeIfPresent(dailyTransactionID, forKey: .dailyTransactionID)
        
    }
}
