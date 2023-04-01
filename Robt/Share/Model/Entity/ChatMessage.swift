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
    let createdAt: Int = .init(Date().timeIntervalSince1970)

    private enum CodingKeys: String, CodingKey {
        case role, content
    }
}
