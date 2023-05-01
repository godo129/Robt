//
//  ImageGenerateViewModel.swift
//  Robt
//
//  Created by hong on 2023/05/01.
//

import Combine
import Foundation

final class ImageGenerateViewModel: InputOutput {

    enum Input {
        case imagePromptInputted(_ prompt: String)
    }

    enum Output {
        case imageGenerated(_ url: String)
        case imageGenerateFailed
    }

    private let usecase: ImageGenerateViewUseCaseProtocol
    private var coordinator: MainCoordinator
    var cancellables: Set<AnyCancellable> = .init()
    var outPut: PassthroughSubject<Output, Never> = .init()
    init(
        usecase: ImageGenerateViewUseCaseProtocol,
        coordinator: MainCoordinator
    ) {
        self.usecase = usecase
        self.coordinator = coordinator
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case let .imagePromptInputted(prompt):
                Task {
                    do {
                        let data = ImageGenerate(prompt: prompt, imageSize: .pixel512x512)
                        let response = try await self.usecase.imageGenerate(data: data)
                        self.outPut.send(.imageGenerated(response[0]))
                    } catch {
                        self.outPut.send(.imageGenerateFailed)
                    }
                }
            }
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
