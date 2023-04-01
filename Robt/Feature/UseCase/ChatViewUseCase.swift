//
//  ChatViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

final class ChatViewUsecase {
    private let openAIRepository: OpenAIRepository
    init(openAIRepository: OpenAIRepository) {
        self.openAIRepository = openAIRepository
    }

    func chatting(text: String) async throws -> [ChatMessage] {
        let chatMessage = ChatMessage(role: .user, content: text)
        return try await openAIRepository.chatting(chatMessage)
    }
}
