//
//  ChatMessage.swift
//  Robt
//
//  Created by hong on 2023/03/29.
//

import Foundation

struct ChatMessage: Hashable, Codable {
    let role: ChatRole
    let content: String
    var createdAt: String? = nil

    private enum CodingKeys: String, CodingKey {
        case role, content
    }
    
    static func translate(
        message: String,
        targetLanguage: Language
    ) -> ChatMessage {
        let prompt = "Translate \(message) to \(targetLanguage.rawValue) and output only translated result"
        return ChatMessage(role: .user, content: prompt)
    }
}
