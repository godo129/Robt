//
//  ChatRepository.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Foundation

final class ChatRepository {
    enum ChatRepositoryError: Error {
        case decodeError
        case responseErorr
        case noUserId
        case deleteChatError
    }

    private let fireStoreProvider: NetworkProvider<FireStoreAPI>
    private let keychainProvider: KeychainProviderProtocol
    init(
        fireStoreProvider: NetworkProvider<FireStoreAPI>,
        keychainProvider: KeychainProviderProtocol
    ) {
        self.fireStoreProvider = fireStoreProvider
        self.keychainProvider = keychainProvider
    }

    private func getUserId() async throws -> String {
        return try await keychainProvider.read(item: .appleAccount())
    }

    func storeChat(_ message: ChatMessage) async throws -> FireStoreChatResponse {
        guard let _ = try? await deleteChats() else {
            throw ChatRepositoryError.deleteChatError
        }
        guard let userID = try? await getUserId() else {
            throw ChatRepositoryError.noUserId
        }
        guard let response = try? await fireStoreProvider.request(
            .postChats(
                userID,
                FireStoreChatRequest([message])
            )
        ) else {
            throw ChatRepositoryError.responseErorr
        }
        guard let data = response.decode(FireStoreChatResponse.self) else {
            throw ChatRepositoryError.decodeError
        }
        return data
    }

    func getChats() async throws -> FireStoreChatResponse {
        guard let userID = try? await getUserId() else {
            throw ChatRepositoryError.noUserId
        }
        guard let response = try? await fireStoreProvider.request(.getChats(userID)) else {
            throw ChatRepositoryError.responseErorr
        }
        guard let data = response.decode(FireStoreChatResponse.self) else {
            throw ChatRepositoryError.decodeError
        }
        return data
    }

    func deleteChats() async throws {
        guard let userID = try? await getUserId() else {
            throw ChatRepositoryError.noUserId
        }
        guard let _ = try? await fireStoreProvider.request(.deleteChats(userID)) else {
            throw ChatRepositoryError.responseErorr
        }
    }
}
