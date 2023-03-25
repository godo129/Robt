//
//  Environment.swift
//  Robt
//
//  Created by hong on 2023/03/22.
//

import Foundation
import Moya

enum FireStore: TargetType {
    
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
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp:
            return nil
        }
    }
}
