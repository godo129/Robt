//
//  AudioTranscriptionViewUsecase.swift
//  Robt
//
//  Created by hong on 2023/05/02.
//

import Foundation

protocol AudioTranscriptionViewUsecaseProtocol {
    func audioTranscription(audioFilePath: String) async throws -> String
}

struct AudioTranscriptionViewUsecase: AudioTranscriptionViewUsecaseProtocol {
    private let openAIRepository: OpenAIRepositoryProtocol
    init(
        openAIRepository: OpenAIRepositoryProtocol
    ) {
        self.openAIRepository = openAIRepository
    }
    func audioTranscription(audioFilePath: String) async throws -> String {
        return try await openAIRepository.audioToTranscription(audioFilePath: audioFilePath).text
    }
}
