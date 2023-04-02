//
//  SignInViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Foundation

protocol SignInViewUseCaseProtocol {
    func signIn() async throws
}

struct SignInViewUseCase: SignInViewUseCaseProtocol {

    enum SignInViewUseCaseError: Error {
        case signInError
    }

    private let appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    init(
        appleAuthenticationRepository: AppleAuthenticationRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.appleAuthenticationRepository = appleAuthenticationRepository
        self.userRepository = userRepository
    }

    func signIn() async throws {
        do {
            let userId = try await appleAuthenticationRepository.signUp()
            _ = try await userRepository.isSignIn(userId: userId)
        } catch {
            throw SignInViewUseCaseError.signInError
        }
    }
}
