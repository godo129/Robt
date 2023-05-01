//
//  HomeViewModel.swift
//  Robt
//
//  Created by hong on 2023/03/28.
//

import Combine
import Foundation

final class HomeViewModel: InputOutput {

    enum Input {
        case chatWithRobotButtonTapped
        case imageGenerateButtonTapped
    }

    enum Output {}

    var outPut: PassthroughSubject<Output, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()

    private let usecase: HomeViewUseCaseProtocol
    private weak var coordinator: MainCoordinator?
    init(
        usecase: HomeViewUseCaseProtocol,
        coordinator: MainCoordinator
    ) {
        self.usecase = usecase
        self.coordinator = coordinator
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .chatWithRobotButtonTapped:
                self.coordinator?.showChatWithRobotViewController()
            case .imageGenerateButtonTapped:
                print("imageGenerateButtonTapped")
                return
            }
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
