//
//  KeychainService.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 08-02-26.
//

import Foundation
import Security

struct KeychainService {
    
    private static let account = "com.sebitay.Finance.token"
    private static let service = "finance-api-service"

    static func saveToken(_ token: String) -> OSStatus {
        let data = Data(token.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
        ]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }

    static func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }

    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    static func isTokenValid(_ token: String) -> Bool {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else { return false }
        
        var payload64 = parts[1]
        
        while payload64.count % 4 != 0 {
            payload64.append("=")
        }
        
        guard let payloadData = Data(base64Encoded: payload64),
            let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
            let exp = json["exp"] as? TimeInterval else {
            return true // Si no hay fecha de expiración, asumimos que no sirve
        }
        
        let expiryDate = Date(timeIntervalSince1970: exp)
        return Date() >= expiryDate
    }
}
