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

        dependecies.register(KeychainProviderProtocol.self, impl: KeychainProvider())

        dependecies.register(
            AppleAuthenticationRepositoryProtocol.self,
            impl: AppleAuthenticationRepository(
                appleProvider: ASAuthorizationAppleIDProvider(),
                keychainProvider: dependecies.resolve(KeychainProviderProtocol.self)
            )
        )

        dependecies.register(
            SignUpViewUseCaseProtocol.self,
            impl: SignUpViewUseCase(
                appleAuthenticationRepository: dependecies.resolve(AppleAuthenticationRepositoryProtocol.self)
            )
        )
    }
}
