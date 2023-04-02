//
//  ChatRepository.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Foundation

final class ChatRepository {
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

    func storeChat(_ message: ChatMessage) async throws {
        let userID = try await getUserId()
        let chat = FirStoreMessage(message: message)
        let request = try await fireStoreProvider.request(
            .postChats(
                userID,
                Chat([chat])
            )
        )
        print(String(data: request, encoding: .utf8)!)
    }

//    func getChats() async throws -> FireStoreChat {
//        let userID = try await getUserId()
//        let response = try await fireStoreProvider.request(.getChats("szLl1G6yNiwQCspEp4Ha"))
//        return response.decode(FireStoreChat.self)!
//    }
}
