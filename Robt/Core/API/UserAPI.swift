//
//  UserAPI.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation

enum UserAPI: API {
    
    case signUp(String)
    
    var baseURL: URL {
        #if DEBUG
        URL(string: "https://firestore.googleapis.com/v1/projects/robt-e2977/databases/(default)/documents")!
        #else
        URL(string: "https://firestore.googleapis.com/v1/projects/robt-dev-a61d5/databases/(default)/documents")!
        #endif
    }
    
    var path: String {
        switch self {
        case .signUp(let string):
            return "/User?documentId=\(string)"
        }
    }
    
    
    var body: Encodable? {
        switch self {
        case .signUp:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .signUp:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp:
            return nil
        }
    }
}
