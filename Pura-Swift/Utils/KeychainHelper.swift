//
//  KeychainHelper.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//

import Security
import Foundation

class KeychainHelper {
    static func saveToken(_ token: String) {
        let data = token.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken"
        ]

        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]

        // Cek apakah token sudah ada
        let status = SecItemCopyMatching(query as CFDictionary, nil)

        if status == errSecSuccess {
            // Jika sudah ada, update
            SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            // Jika belum ada, tambahkan baru
            var newQuery = query
            newQuery[kSecValueData as String] = data
            SecItemAdd(newQuery as CFDictionary, nil)
        }
    }

    static func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        if let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken"
        ]
        SecItemDelete(query as CFDictionary)
    }
}
