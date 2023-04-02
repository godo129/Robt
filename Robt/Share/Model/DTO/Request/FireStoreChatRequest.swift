//
//  FireStoreChatRequest.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Foundation

struct ChatMessage2: Encodable {
    let role: String
    let createdAt: String
    let content: String

    private enum CodingKeys: String, CodingKey {
        case role
        case createdAt = "created_at"
        case content
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(content, forKey: .content)
    }
}

struct Chat: Encodable {
    let messages: [FireStoreMessage]

    private enum RootKey: String, CodingKey {
        case fields
    }

    private enum FieldKey: String, CodingKey {
        case messages
    }

    private enum ArrayKey: String, CodingKey {
        case arrayValue
    }

    private enum ValuesKey: String, CodingKey {
        case values
    }

    func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = rootContainer.nestedContainer(keyedBy: FieldKey.self, forKey: .fields)
        var arrayContainer = fieldContainer.nestedContainer(keyedBy: ArrayKey.self, forKey: .messages)
        var valueContaier = arrayContainer.nestedContainer(keyedBy: ValuesKey.self, forKey: .arrayValue)
        var messagesArrayContainer = valueContaier.nestedUnkeyedContainer(forKey: .values)
        for message in messages {
            var messageContainer = messagesArrayContainer.nestedContainer(keyedBy: MessageCodingKeys.self)
            var fieldContainer = messageContainer.nestedContainer(keyedBy: RootKey.self, forKey: .mapValue)
            try message.encode(to: fieldContainer.superEncoder(forKey: .fields))
        }
    }

    private enum MessageCodingKeys: String, CodingKey {
        case mapValue
    }

    init(_ message: [ChatMessage]) {
        self.messages = message.map { FireStoreMessage(message: $0) }
    }
}
