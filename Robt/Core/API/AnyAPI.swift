//
//  AnyAPI.swift
//  Robt
//
//  Created by hong on 2023/05/01.
//

import Foundation

enum AnyAPI: API {

    case getAny(
        _ urlString: String,
        _ headers: [String: String]? = nil,
        _ parameters: [String: String]? = nil
    )

    var baseURL: URL {
        switch self {
        case let .getAny(urlString, _, _):
            return URL(string: urlString)!
        }
    }

    var path: String {
        return ""
    }

    var method: HTTPMethod {
        switch self {
        case .getAny:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case let .getAny(_, headers, _):
            return headers
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .getAny(_, _, parameters):
            return parameters
        }
    }

    var body: Encodable? {
        switch self {
        case .getAny:
            return nil
        }
    }
}
