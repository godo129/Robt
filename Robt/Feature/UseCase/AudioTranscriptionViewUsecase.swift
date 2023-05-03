//
//  AudioTranscriptionViewUsecase.swift
//  Robt
//
//  Created by hong on 2023/05/02.
//

import Foundation

protocol AudioTranscriptionViewUsecaseProtocol {
    func audioTranscription(audioFilePath: URL) async throws -> String
    func fileExtensionCheck(fileURL: URL) -> Bool
}

struct AudioTranscriptionViewUsecase: AudioTranscriptionViewUsecaseProtocol {

    enum AvailableFileExtension: String, CaseIterable {
        case mp3
        case mp4
        case mpeg
        case mpga
        case m4a
        case wav
        case webm

        static func isAvailable(_ fileExtension: String) -> Bool {
            let availableExtensions = Set(AvailableFileExtension.allCases.map { $0.rawValue })
            return availableExtensions.contains(fileExtension)
        }
    }

    private let openAIRepository: OpenAIRepositoryProtocol
    init(
        openAIRepository: OpenAIRepositoryProtocol
    ) {
        self.openAIRepository = openAIRepository
    }

    func audioTranscription(audioFilePath: URL) async throws -> String {
        return try await openAIRepository.audioToTranscription(audioFilePath: audioFilePath).text
    }

    func fileExtensionCheck(fileURL: URL) -> Bool {
        let fileExtension = fileURL.lastPathComponent.split(separator: ".").map { String($0) }.last ?? ""
        return AvailableFileExtension.isAvailable(fileExtension)
    }
}
