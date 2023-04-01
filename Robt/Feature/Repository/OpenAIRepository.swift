//
//  OpenAIRepository.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

struct OpenAIRepository {
    private let openAIProvider: NetworkProvider<OpenAIAPI>
    init(openAIProvider: NetworkProvider<OpenAIAPI>) {
        self.openAIProvider = openAIProvider
    }

    func chat(_ text: String) async throws {
        do {
            let data = try await openAIProvider.request(.chat(.init(messages: [.init(role: "user", content: text)])))
        } catch {
            print(error)
        }
    }
}
