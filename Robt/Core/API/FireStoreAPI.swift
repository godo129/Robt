//
//  FireStoreAPI.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation

enum FireStoreAPI: API {

    case makeUser(String)
    case deleteUser(String)
    case postChats(String, FireStoreChatRequest)
    case getChats(String)
    case deleteChats(String)

    var baseURL: URL {
        #if DEBUG
            URL(string: "https://firestore.googleapis.com/v1/projects/robt-e2977/databases/(default)/documents")!
        #else
            URL(string: "https://firestore.googleapis.com/v1/projects/robt-dev-a61d5/databases/(default)/documents")!
        #endif
    }

    var path: String {
        switch self {
        case .makeUser:
            return "/users"
        case let .deleteUser(userId):
            return "/users/\(userId)"
        case let .getChats(userId), let .deleteChats(userId):
            return "/chats/\(userId)"
        case .postChats:
            return "/chats"
        }
    }

    var body: Encodable? {
        switch self {
        case .makeUser, .deleteUser, .getChats, .deleteChats:
            return nil
        case let .postChats(_, data):
            return data
        }
    }

    var method: HTTPMethod {
        switch self {
        case .makeUser, .postChats:
            return .post
        case .getChats:
            return .get
        case .deleteUser, .deleteChats:
            return .delete
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .makeUser(userId), let .postChats(userId, _):
            return ["documentId": userId]
        case .deleteUser, .getChats, .deleteChats:
            return nil
        }
    }

    var headers: [String: String]? {
        switch self {
        case .makeUser, .deleteUser, .getChats, .deleteChats:
            return nil
        case .postChats:
            return ["Content-Type": "application/json"]
        }
    }
}
