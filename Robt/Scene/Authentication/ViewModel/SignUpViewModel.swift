//
//  SignUpViewModel.swift
//  Robt
//
//  Created by hong on 2023/03/19.
//

import Combine
import Foundation

final class SignUpViewModel {

    private let signUpViewUseCase: SignUpViewUseCaseProtocol
    private weak var coordinator: AuthenticationCoordinator?

    init(signUpViewUseCase: SignUpViewUseCaseProtocol, coordinator: AuthenticationCoordinator?) {
        self.signUpViewUseCase = signUpViewUseCase
        self.coordinator = coordinator
    }

    enum Input {
        case appleButtonTap
        case emailButtonTap
    }

    enum Output {
        case appleSignUpErrorOccured
    }

    private let outPut: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .appleButtonTap:
                Task {
                    do {
                        let userID = try await self.signUpViewUseCase.appleSignUp()
                        try await self.signUpViewUseCase.registUser(id: userID)
                        self.coordinator?.delegate?.finish(appMode: .authentication)
                    } catch {
                        print(error.localizedDescription)
                        self.outPut.send(.appleSignUpErrorOccured)
                    }
                }
            case .emailButtonTap:
                break
            }
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
