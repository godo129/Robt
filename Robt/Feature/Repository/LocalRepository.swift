//
//  LocalRepository.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Foundation

protocol LocalRepositoryProtocol {
    func save(_ type: KeychainKey) async throws
    func delete(_ type: KeychainKey) async throws
    func update(_ type: KeychainKey) async throws -> String
    func read(_ type: KeychainKey) async throws -> String
}

struct LocalRepository: LocalRepositoryProtocol {
    private let keychainProvider: KeychainProviderProtocol
    init(keychainProvider: KeychainProviderProtocol) {
        self.keychainProvider = keychainProvider
    }

    func save(_ type: KeychainKey) async throws {
        return try await keychainProvider.save(item: type)
    }

    func delete(_ type: KeychainKey) async throws {
        return try await keychainProvider.delete(item: type)
    }

    func update(_ type: KeychainKey) async throws -> String {
        return try await keychainProvider.update(item: type)
    }

    func read(_ type: KeychainKey) async throws -> String {
        return try await keychainProvider.read(item: type)
    }
}
