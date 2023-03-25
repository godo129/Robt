//
//  SignUpViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/03/19.
//

import Foundation

protocol SignUpViewUseCaseProtocol {
    func appleSignUp() async throws -> String
    func registUser(id: String) async throws
}

struct SignUpViewUseCase: SignUpViewUseCaseProtocol {

    private let appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(
        appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.appleAuthenticationRepository = appleAuthenticationRepository
        self.userRepository = userRepository
    }

    func appleSignUp() async throws -> String {
        return try await appleAuthenticationRepository.signUp()
    }

    func registUser(id: String) async throws {
        return try await userRepository.regist(.user(id))
    }
}
