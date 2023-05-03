//
//  AudioTranscriptionViewModel.swift
//  Robt
//
//  Created by hong on 2023/05/02.
//

import Combine
import Foundation

final class AudioTrnascriptionViewModel: InputOutput {

    enum Input {
        case audioSelectButtonTapped
        case audioFileUpload(_ path: URL)
    }

    enum Output {
        case audioSelectButtonDidTap
        case audioFileUploaded(_ transcription: String)
        case audioFileUploadFailed
        case fileExtensionNotAvailable
        case fileByteIsTooLarge
    }

    var outPut: PassthroughSubject<Output, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()

    private let usecase: AudioTranscriptionViewUsecaseProtocol
    private weak var coordinator: MainCoordinator?
    init(
        usecase: AudioTranscriptionViewUsecaseProtocol,
        coordinator: MainCoordinator
    ) {
        self.usecase = usecase
        self.coordinator = coordinator
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {

        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case let .audioFileUpload(path):
                Task {
                    do {
                        guard self.usecase.fileExtensionCheck(fileURL: path) == true else {
                            self.outPut.send(.fileExtensionNotAvailable)
                            return
                        }
                        guard self.usecase.sizeLimitCheck(fileURL: path) == true else {
                            self.outPut.send(.fileByteIsTooLarge)
                            return
                        }
                        let transcription = try await self.usecase.audioTranscription(audioFilePath: path)
                        print("transcription은 다음과 같습니다 :", transcription)
                        self.outPut.send(.audioFileUploaded(transcription))
                    } catch {
                        print(error)
                        self.outPut.send(.audioFileUploadFailed)
                    }
                }
            case .audioSelectButtonTapped:
                self.outPut.send(.audioSelectButtonDidTap)
            }
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
