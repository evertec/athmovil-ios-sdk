//
//  KeychainHelper.swift
//  athmovil-checkout
//
//  Created by Ismael Paredes on 14/02/23.
//  Copyright © 2023 Evertec. All rights reserved.
//

import Foundation

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    func save<T>(_ item: T, service: String) where T : Codable {
        
        do {
            let data = try JSONEncoder().encode(item)
            save(data, service: service)
            
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    func save(_ data: Data, service: String) {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "athm_checkout",
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
    
    func read<T>(service: String, type: T.Type) -> T? where T : Codable {
        
        // Read item data from keychain
        guard let data = read(service: service) else {
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    func read(service: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: "athm_checkout",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        // Read item from keychain
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String) {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: "athm_checkout",
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
}
