//
//  UserRepository.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func regist(_ type: UserAPI) async throws
    func delete(_ type: UserAPI) async throws
}

final class UserRepository: UserRepositoryProtocol {
    private let userProvider: NetworkProvider<UserAPI>
    init(userProvider: NetworkProvider<UserAPI>) {
        self.userProvider = userProvider
    }

    private func request(_ type: UserAPI) async throws -> Data {
        return try await userProvider.request(type)
    }

    func regist(_ type: UserAPI) async throws {
        try await request(type)
    }

    func delete(_ type: UserAPI) async throws {
        try await request(type)
    }
}
