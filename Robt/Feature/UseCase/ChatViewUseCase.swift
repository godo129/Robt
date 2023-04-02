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

    func fetchChats() async throws -> [ChatMessage] {
        return try await chatRepository.getChats().toEntity()
    }

    func saveChats(_ messages: [ChatMessage]) async throws -> [ChatMessage] {
        return try await chatRepository.storeChats(messages).toEntity()
    }

    func chatting(text: String) async throws -> [ChatMessage] {
        let chatMessage = ChatMessage(role: .user, content: text)
        do {

            var chats = try await fetchChats()
            chats.append(chatMessage)
            let robotChat = try await openAIRepository.chatting(chats).toEntity()
            chats += robotChat
            let savedChats = try await saveChats(chats)
            return savedChats
        } catch {
//            throw error
            let robotChat = try await openAIRepository.chatting([chatMessage]).toEntity()
            let savedChats = try await saveChats(robotChat)
            return savedChats
        }
    }

    func deleteAllChats() async throws {
        try await chatRepository.deleteChats()
    }
}
