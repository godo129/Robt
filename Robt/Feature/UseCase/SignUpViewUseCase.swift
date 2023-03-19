//
//  SignUpViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/03/19.
//

import Foundation

protocol SignUpViewUseCaseProtocol {
    func appleSignUp() async throws -> String
}

struct SignUpViewUseCase: SignUpViewUseCaseProtocol {

    private let appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol

    init(appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol) {
        self.appleAuthenticationRepository = appleAuthenticationRepository
    }

    func appleSignUp() async throws -> String {
        return try await appleAuthenticationRepository.signUp()
    }
}
