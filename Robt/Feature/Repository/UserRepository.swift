//
//  UserRepository.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func regist(userId: String) async throws
    func delete(userId: String) async throws
    func getUserId() async throws -> String
    func isSignIn(userId: String) async throws
}

final class UserRepository: UserRepositoryProtocol {

    enum UserRepository: Error {
        case signInError
    }

    private let fireStoreProvider: NetworkProvider<FireStoreAPI>
    private let keychainProvider: KeychainProviderProtocol
    init(
        fireStoreProvider: NetworkProvider<FireStoreAPI>,
        keychainProvider: KeychainProviderProtocol
    ) {
        self.fireStoreProvider = fireStoreProvider
        self.keychainProvider = keychainProvider
    }

    private func request(_ type: FireStoreAPI) async throws -> Data {
        return try await fireStoreProvider.request(type)
    }

    func regist(userId: String) async throws {
        try await request(.makeUser(userId))
    }

    func delete(userId: String) async throws {
        try await request(.deleteUser(userId))
    }

    func getUserId() async throws -> String {
        return try await keychainProvider.read(item: .appleAccount())
    }

    func isSignIn(userId: String) async throws {
        do {
            let data = try await request(.getUser(userId))
            let response = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard response?["error"] is [String: Any] else {
                return
            }
            throw UserRepository.signInError
        } catch {
            print(error)
            throw UserRepository.signInError
        }
    }
}
