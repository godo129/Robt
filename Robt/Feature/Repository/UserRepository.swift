//
//  UserRepository.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func regist(_ type: UserAPI) async throws
}

final class UserRepository: UserRepositoryProtocol {
    private let userProvider: NetworkProvider<UserAPI>
    init(userProvider: NetworkProvider<UserAPI>) {
        self.userProvider = userProvider
    }

    func regist(_ type: UserAPI) async throws {
        try await userProvider.request(type)
    }
}
