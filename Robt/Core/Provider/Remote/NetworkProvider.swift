//
//  NetworkProvider.swift
//  Robt
//
//  Created by hong on 2023/03/25.
//

import Foundation
import Alamofire

struct NetworkProvider<T: API> {
    
    enum NetworkError: Error {
        case noData
        case error
    }
    
    func request(_ element: T) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(element)
                .validate(statusCode: 200..<300)
                .response { response in
                    guard response.error != nil else {
                        continuation.resume(throwing: NetworkError.error)
                        return
                    }
                    guard let data = response.data else {
                        continuation.resume(throwing: NetworkError.noData)
                        return 
                    }
                    continuation.resume(returning: data)
                }
        }
    }
}
