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
}

final class UserRepository: UserRepositoryProtocol {
    private let userProvider: NetworkProvider<FireStoreAPI>
    init(userProvider: NetworkProvider<FireStoreAPI>) {
        self.userProvider = userProvider
    }

    private func request(_ type: FireStoreAPI) async throws -> Data {
        return try await userProvider.request(type)
    }

    func regist(userId: String) async throws {
        try await request(.makeUser(userId))
    }

    func delete(userId: String) async throws {
        try await request(.deleteUser(userId))
    }
}
