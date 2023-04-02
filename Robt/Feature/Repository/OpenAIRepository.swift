//
//  OpenAIRepository.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

final class OpenAIRepository {
//
//    private var chatMessages: [ChatMessage] = []

    enum OpenAIRepositoyError: Error {
        case responseError
        case decodeError
    }

    private let openAIProvider: NetworkProvider<OpenAIAPI>
    init(openAIProvider: NetworkProvider<OpenAIAPI>) {
        self.openAIProvider = openAIProvider
    }

    func chatting(_ messages: [ChatMessage]) async throws -> ChatResponse {
        guard let data = try? await openAIProvider.request(
            .chat(ChatRequest(messages: messages))
        ) else {
            throw OpenAIRepositoyError.responseError
        }
        guard let chats = data.decode(ChatResponse.self) else {
            throw OpenAIRepositoyError.decodeError
        }
//        updateChat(chats.toEntity())
        return chats
    }
//
//    private func updateChat(_ messages: [ChatMessage]) {
//        chatMessages.append(messages[0])
//    }
}
