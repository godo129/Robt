//
//  ChatViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

final class ChatViewUsecase {
    private let openAIRepository: OpenAIRepository
    private let chatRepository: ChatRepository
    init(
        openAIRepository: OpenAIRepository,
        chatRepository: ChatRepository
    ) {
        self.openAIRepository = openAIRepository
        self.chatRepository = chatRepository
    }

    func fetchChatting() async throws -> [ChatMessage] {
        return try await chatRepository.getChats().toEntity()
    }

    func chatting(text: String) async throws -> [ChatMessage] {
        let chatMessage = ChatMessage(role: .user, content: text)
        return try await openAIRepository.chatting(chatMessage)
    }
}
