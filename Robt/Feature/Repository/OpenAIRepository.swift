//
//  OpenAIRepository.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

protocol OpenAIRepositoryProtocol {
    func chatting(_ messages: [ChatMessage]) async throws -> ChatResponse
    func imageGenerate(_ imageGenerate: ImageGenerate) async throws -> ImageGenerateResponse
    func getImageData(urlString: String) async throws -> Data
}

final class OpenAIRepository: OpenAIRepositoryProtocol {

    enum OpenAIRepositoyError: Error {
        case responseError
        case decodeError
    }

    private let openAIProvider: NetworkProvider<OpenAIAPI>
    private let anyProvider: NetworkProvider<AnyAPI>
    init(
        openAIProvider: NetworkProvider<OpenAIAPI>,
        anyProvider: NetworkProvider<AnyAPI>
    ) {
        self.openAIProvider = openAIProvider
        self.anyProvider = anyProvider
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
        return chats
    }

    func imageGenerate(_ imageGenerate: ImageGenerate) async throws -> ImageGenerateResponse {
        let request = ImageGenerateRequest(imageGenerate)
        guard let data = try? await openAIProvider.request(
            .imageGenerate(request)
        ) else {
            throw OpenAIRepositoyError.responseError
        }
        guard let response = data.decode(ImageGenerateResponse.self) else {
            throw OpenAIRepositoyError.decodeError
        }
        return response
    }

    func getImageData(urlString: String) async throws -> Data {
        guard let data = try? await anyProvider.request(.getAny(urlString)) else {
            throw OpenAIRepositoyError.responseError
        }
        return data
    }
    
    func audioToTranscription(audioFilePath: String) async throws -> AudioTranscriptionResponse {
        guard let data = try? await openAIProvider.request(.audioTranscription(audioFilePath)) else {
            throw OpenAIRepositoyError.responseError
        }
        guard let response = data.decode(AudioTranscriptionResponse.self) else {
            throw OpenAIRepositoyError.decodeError
        }
        return response
    }
}
