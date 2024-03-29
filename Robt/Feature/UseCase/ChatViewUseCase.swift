//
//  ChatViewUseCase.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

protocol ChatViewUsecaseProtocol {
    func fetchChats() async throws -> [ChatMessage]
    func saveChats(_ messages: [ChatMessage]) async throws -> [ChatMessage]
    func chatting(text: String) async throws -> [ChatMessage]
    func deleteAllChats() async throws
    func reportChat(_ index: Int) async throws -> [ChatMessage]
}

final class ChatViewUsecase: ChatViewUsecaseProtocol {

    enum ChatViewUsecaseError: Error {
        case deleteChatIndexError
    }

    private let openAIRepository: OpenAIRepositoryProtocol
    private let chatRepository: ChatRepositoryProtocol
    init(
        openAIRepository: OpenAIRepositoryProtocol,
        chatRepository: ChatRepositoryProtocol
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
        let chatMessage = ChatMessage(role: .user, content: text, createdAt: Date().toTimeStamp)
        do {

            var chats = try await fetchChats()
            chats.append(chatMessage)
            let robotChat = try await openAIRepository.chatting(chats).toEntity()
            chats += robotChat
            let savedChats = try await saveChats(chats)
            return savedChats
        } catch {
//            throw error
            var robotChat = try await openAIRepository.chatting([chatMessage]).toEntity()
            if robotChat.count == 1 {
                robotChat = [chatMessage] + robotChat
            }
            let savedChats = try await saveChats(robotChat)
            return savedChats
        }
    }

    func deleteAllChats() async throws {
        try await chatRepository.deleteChats()
    }

    func reportChat(_ index: Int) async throws -> [ChatMessage] {
        var chats = try await chatRepository.getChats().toEntity()
        if index < chats.count {
            _ = chats.remove(at: index)
            if chats.isEmpty {
                try await deleteAllChats()
                return []
            } else {
                return try await chatRepository.storeChats(chats).toEntity()
            }
        } else {
            throw ChatViewUsecaseError.deleteChatIndexError
        }
    }
}
