//
//  NetworkProvider.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Alamofire
import Foundation

struct NetworkProvider<T: API> {

    enum NetworkError: Error {
        case noResponse
        case error
    }

    @MainActor
    func request(_ element: T) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(element)
                .response { response in
                    guard response.error == nil else {
                        continuation.resume(throwing: NetworkError.error)
                        return
                    }
                    guard let data = response.data else {
                        continuation.resume(throwing: NetworkError.noResponse)
                        return
                    }
                    print(String(data: data, encoding: .utf8) ?? "")
                    continuation.resume(returning: data)
                }
        }
    }

    @MainActor
    func multiPartRequest(
        url: String,
        headers: HTTPHeaders,
        parameters: [String: String],
        fileURL: URL
    ) async throws -> Data {

        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(
                    fileURL,
                    withName: "file",
                    fileName: fileURL.lastPathComponent,
                    mimeType: "audio/*"
                )
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: url, method: .post, headers: headers)
                .response { response in
                    guard response.error == nil else {
                        continuation.resume(throwing: NetworkError.error)
                        return
                    }
                    guard let data = response.data else {
                        continuation.resume(throwing: NetworkError.noResponse)
                        return
                    }
                    print("url: ", response.request?.url?.absoluteString ?? "")
                    print("httpMethod: ", response.request?.httpMethod ?? "")
                    print("response: ", String(data: data, encoding: .utf8) ?? "")
                    continuation.resume(returning: data)
                }
        }
    }
}
