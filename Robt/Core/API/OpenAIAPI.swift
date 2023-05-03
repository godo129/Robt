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
    case audioTranscription(_ audioFilePath: URL)

    var baseURL: URL {
        URL(string: "https://api.openai.com/v1")!
    }

    var path: String {
        switch self {
        case .chat:
            return "/chat/completions"
        case .imageGenerate:
            return "/images/generations"
        case .audioTranscription:
            return "/audio/transcriptions"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .chat, .imageGenerate, .audioTranscription:
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
        case .audioTranscription:
            return [
                "Authorization": "Bearer \(APIEnvironment.openAIAPIKey)",
                "Content-Type": "multipart/form-data; boundary=bbb1234"
            ]
        }
    }

    var parameters: [String: String]? {
        switch self {
        case .chat, .imageGenerate:
            return nil
        case .audioTranscription:
            return ["model": "whisper-1"]
        }
    }

    var body: Encodable? {
        switch self {
        case let .chat(chatRequest):
            return chatRequest
        case let .imageGenerate(request):
            return request
        case let .audioTranscription(audioFilePath):
            return Data.audiomultipartFormData(audioURL: audioFilePath)
        }
    }

    var isMultipart: Bool {
        switch self {
        case .chat, .imageGenerate:
            return false
        case .audioTranscription:
            return true
        }
    }
}
