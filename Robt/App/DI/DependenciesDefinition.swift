//
//  DependenciesDefinition.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import AuthenticationServices
import Foundation

final class DependenciesDefinition {
    func inject() {
        let dependecies = DependenciesContainer.share

        // MARK: - Provider

        dependecies.register(KeychainProviderProtocol.self, impl: KeychainProvider())

        // MARK: - Repository

        dependecies.register(
            AppleAuthenticationRepositoryProtocol.self,
            impl: AppleAuthenticationRepository(
                appleProvider: ASAuthorizationAppleIDProvider(),
                keychainProvider: dependecies.resolve(KeychainProviderProtocol.self)
            )
        )
        dependecies.register(
            UserRepositoryProtocol.self,
            impl: UserRepository(userProvider: NetworkProvider<UserAPI>())
        )

        // MARK: - UseCase

        dependecies.register(
            SignUpViewUseCaseProtocol.self,
            impl: SignUpViewUseCase(
                appleAuthenticationRepository: dependecies.resolve(AppleAuthenticationRepositoryProtocol.self),
                userRepository: dependecies.resolve(UserRepositoryProtocol.self)
            )
        )
        dependecies.register(
            SignInViewUseCaseProtocol.self,
            impl: SignInViewUseCase(
                appleAuthenticationRepository: dependecies.resolve(AppleAuthenticationRepositoryProtocol.self)
            )
        )
    }
}
