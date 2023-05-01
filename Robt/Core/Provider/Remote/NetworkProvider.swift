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
}
