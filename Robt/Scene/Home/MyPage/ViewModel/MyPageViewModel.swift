//
//  MyPageViewModel.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Combine
import Foundation

final class MyPageViewModel: InputOutput {
    enum Input {
        case signOutButtonTapped
        case withdrawalButtonTapped
    }

    enum Output {
        case signOutError
        case withdrawalError
    }

    var outPut: PassthroughSubject<Output, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    private let usecase: MyPageViewUseCaseProtocol
    private weak var coordinator: MyPageCoordinator?

    init(
        usecase: MyPageViewUseCaseProtocol,
        coordinator: MyPageCoordinator
    ) {
        self.usecase = usecase
        self.coordinator = coordinator
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {

        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .signOutButtonTapped:
                Task {
                    do {
                        try await self.usecase.signOut()
                        self.coordinator?.delegate?.finish(tabType: .mypage)
                    } catch {
                        self.outPut.send(.signOutError)
                    }
                }
            case .withdrawalButtonTapped:
                Task {
                    do {
                        try await self.usecase.withdrawal()
                    } catch {
                        self.outPut.send(.withdrawalError)
                    }
                }
            }
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
