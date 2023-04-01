//
//  ChatWithRobotViewModel.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Combine
import Foundation

final class ChatWithRobotViewModel: InputOutput {

    enum Input {
        case message(String)
    }

    enum Output {
        case chatMessages([ChatMessage])
        case chatError(Error)
    }

    var outPut: PassthroughSubject<Output, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    private var coordinator: MainCoordinator?
    private let useCase: ChatViewUsecase

    init(
        useCase: ChatViewUsecase,
        coordinator: MainCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {

        input.sink { event in
            switch event {
            case let .message(message):
                Task {
                    do {
                        let chats = try await self.useCase.chatting(text: message)
                        self.outPut.send(.chatMessages(chats))
                    } catch {
                        self.outPut.send(.chatError(error))
                    }
                }
            }
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
