//
//  KeychainService.swift
//
//
//  Created by 최제환 on 12/14/23.
//

import Foundation
import Security

public protocol KeychainService {
    func create(_ account: String, _ value: String) -> (isSucceed: Bool, resultMessage: String)
    func read(_ account: String) -> (readValue: String?, resultMessage: String)
    func update(_ account: String, _ value: String) -> (isSucceed: Bool, resultMessage: String)
    func deleteItem(key: String) -> (isSucceed: Bool, resultMessage: String)
}

public final class KeychainServiceImp: KeychainService {
    
    private let service: String
    
    public init() {
        self.service = "randychoi.PlaceStory"
    }
    
    public func create(_ account: String, _ value: String) -> (isSucceed: Bool, resultMessage: String) {
        guard let data = value.data(using: .utf8) else {
            return (false, "don't convert to Data")
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return (true, status.description)
        } else if status == errSecDuplicateItem {
            return update(account, value)
        }
        
        return (false, status.description)
    }
    
    public func read(_ account: String) -> (readValue: String?, resultMessage: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let readItem = item as? [String: Any],
               let data = readItem[kSecValueData as String] as? Data,
               let readValue = String(data: data, encoding: .utf8) {
                return (readValue, status.description)
            }
        }
        
        return (nil, status.description)
    }
    
    public func update(_ account: String, _ value: String) -> (isSucceed: Bool, resultMessage: String) {
        guard let data = value.data(using: .utf8) else {
            return (false, "don't convert to Data")
        }
        
        let currentQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ]
        
        let updateQuery: [CFString: Any] = [
            kSecValueData: data
        ]
        
        let status = SecItemUpdate(currentQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess {
            return (true, status.description)
        } else {
            return (false, status.description)
        }
    }
    
    public func deleteItem(key: String) -> (isSucceed: Bool, resultMessage: String) {
        let deleteQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        if status == errSecSuccess {
            return (true, status.description)
        }
        
        return (false, status.description)
    }
}
