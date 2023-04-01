//
//  OpenAIAPI.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

enum OpenAIAPI: API {

    case chat(ChatRequest)

    var baseURL: URL {
        URL(string: "https://api.openai.com/v1")!
    }

    var path: String {
        switch self {
        case .chat:
            return "/chat/completions"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .chat:
            return .post
        }
    }

    var headers: [String: String]? {
        switch self {
        case .chat:
            return [
                "Authorization": "Bearer \(APIEnvironment.openAIAPIKey)",
                "Content-Type": "application/json"
            ]
        }
    }

    var parameters: [String: String]? {
        switch self {
        case .chat:
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        case let .chat(chatRequest):
            return chatRequest
        }
    }
}
