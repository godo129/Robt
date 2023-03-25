//
//  UserRepository.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func signUp(_ type: UserAPI) async throws -> Data
}

final class UserRepository: UserRepositoryProtocol {
    private let userProvider: NetworkProvider<UserAPI>
    init(userProvider: NetworkProvider<UserAPI>) {
        self.userProvider = userProvider
    }
    func signUp(_ type: UserAPI) async throws -> Data {
        return try await userProvider.request(type)
    }
}
