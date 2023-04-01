//
//  ChatResponse.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

struct ChatResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]

    struct Usage: Decodable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int

        private enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }

    struct Choice: Decodable {
        let message: ChatMessage
        let finishReason: String
        let index: Int

        private enum CodingKeys: String, CodingKey {
            case message, index
            case finishReason = "finish_reason"
        }
    }

    func toEntity() -> [ChatMessage] {
        return choices.map { $0.message }
    }
}
