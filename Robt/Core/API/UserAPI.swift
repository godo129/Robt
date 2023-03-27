//
//  UserAPI.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation

enum UserAPI: API {

    case user(String)
    case userCollection(String)

    var baseURL: URL {
        #if DEBUG
            URL(string: "https://firestore.googleapis.com/v1/projects/robt-e2977/databases/(default)/documents")!
        #else
            URL(string: "https://firestore.googleapis.com/v1/projects/robt-dev-a61d5/databases/(default)/documents")!
        #endif
    }

    var path: String {
        switch self {
        case .user:
            return "/users"
        case let .userCollection(userId):
            return "/users/\(userId)"
        }
    }

    var body: Encodable? {
        switch self {
        case .user, .userCollection:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .user:
            return .post
        case .userCollection:
            return .delete
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .user(string):
            return ["documentId": string]
        case .userCollection:
            return nil
        }
    }

    var headers: [String: String]? {
        switch self {
        case .user, .userCollection:
            return nil
        }
    }
}
