//
//  ChatRequest.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

struct ChatRequest: Encodable {
    let model: String = "gpt-3.5-turbo"
    let messages: [Message]
    let temperature: Float = APIEnvironment.openAITemperature
    let maxTokens: Int = APIEnvironment.openAIMaxTokens
    let stop: [String] = ["aaaaaa"]

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stop
        case maxTokens = "max_tokens"
    }

    struct Message: Encodable {
        let role: String
        let content: String
    }
}
