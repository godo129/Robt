//
//  SignInViewModel.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Combine
import Foundation

final class SignInViewModel: InputOutput {

    enum Input {
        case appleSignInButtonTapped
    }

    enum Output {
        case signInError
    }

    var cancellables: Set<AnyCancellable> = .init()

    var outPut: PassthroughSubject<Output, Never> = .init()

    private let usecase: SignInViewUseCaseProtocol
    private let coordinator: AuthenticationCoordinator
    init(
        usecase: SignInViewUseCaseProtocol,
        coordinator: AuthenticationCoordinator
    ) {
        self.usecase = usecase
        self.coordinator = coordinator
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .appleSignInButtonTapped:
                Task {
                    do {
                        let data: () = try await self.usecase.signIn()
                        self.coordinator.delegate?.finish(appMode: .authentication)
                    } catch {
                        print(error)
                        self.outPut.send(.signInError)
                    }
                }
            }
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
