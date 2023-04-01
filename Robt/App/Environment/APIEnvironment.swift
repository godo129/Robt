//
//  APIEnvironment.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

enum APIEnvironment {
    static let openAIAPIKey: String = Bundle.main.object(
        forInfoDictionaryKey: "OpenAIAPIKey"
    ) as! String
    static var openAITemperature: Float = 0.5
    static var openAIMaxTokens: Int = 200
    static var chatModel: String = "gpt-3.5-turbo"
}
