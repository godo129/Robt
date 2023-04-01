//
//  OpenAIRepository.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

final class OpenAIRepository {
    private let openAIProvider: NetworkProvider<OpenAIAPI>
    init(openAIProvider: NetworkProvider<OpenAIAPI>) {
        self.openAIProvider = openAIProvider
    }

    func chat(_ message: ChatMessage) async throws {
        do {
            let data = try await openAIProvider.request(.chat(.init(messages: [message])))
            print(data.decode(ChatResponse.self))
        } catch {
            print(error)
        }
    }
}
