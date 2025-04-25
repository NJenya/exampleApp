//
//  KeychainService.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 02.03.2025.
//
import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    enum ItemClass {
        case generic
        case password
        
        var rawValue: CFString {
            switch self {
            case .generic: return kSecClassGenericPassword
            case .password: return kSecClassInternetPassword
            }
        }
    }

    func saveItem<T: Encodable>(_ item: T, key: String, itemClass: ItemClass) throws {
        let itemData = try JSONEncoder().encode(item)
        
        let query: [String: AnyObject] = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
            kSecValueData as String: itemData as AnyObject
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            let updateQuery: [String: AnyObject] = [kSecValueData as String: itemData as AnyObject]
            let updateStatus = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)

            if updateStatus != errSecSuccess {
                throw KeychainError.unexpected(updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unexpected(status)
        }
    }

    func retrieveItem<T: Decodable>(key: String, itemClass: ItemClass, as type: T.Type) -> T? {
        let query: [String: AnyObject] = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
            kSecReturnData as String: true as AnyObject
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else { return nil }

        return try? JSONDecoder().decode(T.self, from: data)
    }

    func deleteItem(key: String, itemClass: ItemClass) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError.unexpected(status)
        }
    }
}

enum KeychainError: Error {
    case duplicateItem
    case unexpected(OSStatus)
}
