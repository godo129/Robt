//
//  MyPageViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Foundation

protocol MyPageViewUseCaseProtocol {
    func signOut() async throws
    func withdrawal() async throws
}

final class MyPageViewUseCase: MyPageViewUseCaseProtocol {

    private let appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let localRepository: LocalRepositoryProtocol

    init(
        appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol,
        userRepository: UserRepositoryProtocol,
        localRepository: LocalRepositoryProtocol
    ) {
        self.appleAuthenticationRepository = appleAuthenticationRepository
        self.userRepository = userRepository
        self.localRepository = localRepository
    }

    func signOut() async throws {
        return try await localRepository.delete(.appleAccount())
    }

    func withdrawal() async throws {
        let userId = try await localRepository.read(.appleAccount())
        try await userRepository.delete(.userCollection(userId))
    }
}
