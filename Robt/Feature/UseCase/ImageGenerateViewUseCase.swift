//
//  ImageGenerateViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/05/01.
//

import Foundation

protocol ImageGenerateViewUseCaseProtocol {
    func imageGenerate(data: ImageGenerate) async throws -> [String]
}

struct ImageGenerateViewUseCase: ImageGenerateViewUseCaseProtocol {
    private let openAIRepository: OpenAIRepositoryProtocol
    init(
        openAIRepository: OpenAIRepositoryProtocol
    ) {
        self.openAIRepository = openAIRepository
    }

    private func translatePrompt(message: String) async throws -> String {
        let prompt = ChatMessage.translate(
            message: message,
            targetLanguage: .english
        )

        return try await openAIRepository.chatting([prompt]).choices.map { $0.message.content }[0]
    }

    func imageGenerate(data: ImageGenerate) async throws -> [String] {
        do {
            var data = data
            let translatedPrompt = try await translatePrompt(message: data.prompt)
            data.prompt = translatedPrompt
            return try await openAIRepository.imageGenerate(data).data.map { $0.url }
        } catch {
            throw error
        }
    }
}
