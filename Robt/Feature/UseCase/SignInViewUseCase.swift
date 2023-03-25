//
//  SignInViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Foundation

protocol SignInViewUseCaseProtocol {
    func signIn() async throws -> String
}

struct SignInViewUseCase: SignInViewUseCaseProtocol {
    private let appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol
    init(appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol) {
        self.appleAuthenticationRepository = appleAuthenticationRepository
    }

    func signIn() async throws -> String {
        return try await appleAuthenticationRepository.signIn()
    }
}
