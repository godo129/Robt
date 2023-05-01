//
//  ImageGenerateViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/05/01.
//

import Foundation

protocol ImageGenerateViewUseCaseProtocol {
    func imageGenerate(data: ImageGenerate) async throws -> Data
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

    func imageGenerate(data: ImageGenerate) async throws -> Data {
        do {
            var data = data
            let translatedPrompt = try await translatePrompt(message: data.prompt)
            print("번역전 :", data.prompt)
            print("번역 후 :", translatedPrompt)
            data.prompt = translatedPrompt
            let imageURL = try await openAIRepository.imageGenerate(data).data.map { $0.url }[0]
            return try await openAIRepository.getImageData(urlString: imageURL)
        } catch {
            throw error
        }
    }
}
