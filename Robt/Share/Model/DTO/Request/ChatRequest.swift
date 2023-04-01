//
//  ChatRequest.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

struct ChatRequest: Encodable {
    let model: String = APIEnvironment.chatModel
    let messages: [ChatMessage]
    let temperature: Float = APIEnvironment.openAITemperature
    let maxTokens: Int = APIEnvironment.openAIMaxTokens
    let stop: [String] = ["stop Chat"]

    private enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stop
        case maxTokens = "max_tokens"
    }
}
