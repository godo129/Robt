//
//  KeychainProvider.swift
//  Robt
//
//  Created by hong on 2023/03/15.
//

import Foundation

protocol KeychainKeyType {
    var value: String { get }
    var type: String { get }
}

enum KeychainKey: KeychainKeyType {
    case appleAccount(String? = nil)

    var value: String {
        switch self {
        case let .appleAccount(string):
            return string ?? ""
        }
    }

    var type: String {
        switch self {
        case .appleAccount:
            return "appleAccount"
        }
    }
}

protocol KeychainProviderProtocol {
    func save(item: KeychainKey) async throws
    func delete(item: KeychainKey) async throws
    func update(item: KeychainKey) async throws -> String
    func read(item: KeychainKey) async throws -> String
}

struct KeychainProvider: KeychainProviderProtocol {

    enum KeychainError: Error, LocalizedError {
        case duplicateError
        case noItem
        case unKnown(OSStatus)
        case readDataConvertingError
        case deleteError

        var errorDescription: String? {
            switch self {
            case .duplicateError:
                return "duplicateError"
            case .noItem:
                return "noItem"
            case .unKnown:
                return "unKnown"
            case .readDataConvertingError:
                return "readDataConvertingError"
            case .deleteError:
                return "deleteError"
            }
        }
    }

    func save(item: KeychainKey) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let valueEncryption: Data = item.value.data(using: .utf8)!
            let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword,
                                              kSecAttrService as String: "Robt" as AnyObject,
                                              kSecAttrType as String: item.type as AnyObject,
                                              kSecValueData as String: valueEncryption as AnyObject]
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status != errSecDuplicateItem else {
                continuation.resume(throwing: KeychainError.duplicateError)
                return
            }
            guard status == errSecSuccess else {
                continuation.resume(throwing: KeychainError.unKnown(status))
                return
            }
            continuation.resume(returning: ())
        }
    }

    func delete(item: KeychainKey) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrService as String: "Robt",
                                        kSecAttrType as String: item.type]
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess else {
                continuation.resume(throwing: KeychainError.unKnown(status))
                return
            }
            continuation.resume(returning: ())
        }
    }

    func update(item: KeychainKey) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let valueEncryption: Data = item.value.data(using: .utf8)!
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrService as String: "Robt",
                                        kSecAttrType as String: item.type]
            let attribute: [String: Any] = [kSecValueData as String: valueEncryption]
            let status = SecItemUpdate(query as CFDictionary, attribute as CFDictionary)
            guard status != errSecItemNotFound
            else {
                continuation.resume(throwing: KeychainError.noItem)
                return
            }
            guard status == errSecSuccess else {
                continuation.resume(throwing: KeychainError.unKnown(status))
                return
            }
            continuation.resume(returning: item.value)
        }
    }

    func read(item: KeychainKey) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrService as String: "Robt",
                                        kSecAttrType as String: item.type,
                                        kSecReturnData as String: true,
                                        kSecMatchLimit as String: kSecMatchLimitOne]
            var result: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            guard status != errSecItemNotFound
            else {
                continuation.resume(throwing: KeychainError.noItem)
                return
            }
            guard status == errSecSuccess else {
                continuation.resume(throwing: KeychainError.unKnown(status))
                return
            }
            guard let data = result as? Data else {
                continuation.resume(throwing: KeychainError.readDataConvertingError)
                return
            }
            guard let value = String(data: data, encoding: .utf8) else {
                continuation.resume(throwing: KeychainError.readDataConvertingError)
                return
            }
            continuation.resume(returning: value)
        }
    }
}
