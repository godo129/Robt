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
    let createdAt: Int = .init(Int(Date().timeIntervalSince1970 * 1000))

    private enum CodingKeys: String, CodingKey {
        case role, content
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(role)
        hasher.combine(content)
        hasher.combine(createdAt)
    }
}
