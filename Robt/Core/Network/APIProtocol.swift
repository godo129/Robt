//
//  APIProtocol.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Alamofire
import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

protocol API: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    var body: Encodable? { get }
    var isMultipart: Bool { get }
    func asURLRequest() throws -> URLRequest
}

extension API {
    func asURLRequest() throws -> URLRequest {
        var url = URLComponents(string: baseURL.absoluteString + path)!
        if let parameters {
            url.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1) }
        }
        var request = try URLRequest(url: url.asURL())
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        print("url: ", request.urlRequest?.url?.absoluteString ?? "url 없음")
        print("httpMethod: ", request.urlRequest?.httpMethod ?? "httpMethod 없음")
        if isMultipart {
            let data = body as? Data
            print("multipart/form-data 입니다", String(data: data ?? Data(), encoding: .utf8) ?? "")
            request.httpBody = body as? Data
            return request
        }
        if let data = body {
            request.httpBody = data.toJson
            print(String(data: data.toJson!, encoding: .utf8) ?? "body 없음")
        }
        return request
    }

    var isMultipart: Bool {
        return false
    }
}
