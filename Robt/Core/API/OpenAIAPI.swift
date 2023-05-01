//
//  OpenAIAPI.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

enum OpenAIAPI: API {

    case chat(ChatRequest)
    case imageGenerate(_ request: ImageGenerateRequest)

    var baseURL: URL {
        URL(string: "https://api.openai.com/v1")!
    }

    var path: String {
        switch self {
        case .chat:
            return "/chat/completions"
        case .imageGenerate:
            return "/images/generations"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .chat, .imageGenerate:
            return .post
        }
    }

    var headers: [String: String]? {
        switch self {
        case .chat, .imageGenerate:
            return [
                "Authorization": "Bearer \(APIEnvironment.openAIAPIKey)",
                "Content-Type": "application/json"
            ]
        }
    }

    var parameters: [String: String]? {
        switch self {
        case .chat, .imageGenerate:
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        case let .chat(chatRequest):
            return chatRequest
        case let .imageGenerate(request):
            return request
        }
    }
}
