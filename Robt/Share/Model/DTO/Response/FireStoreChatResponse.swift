//
//  FireStoreChatResponse.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Foundation

struct FireStoreChatResponse: Decodable {
    let name: String?
    let messages: [FireStoreMessage]
    let createTime: String?
    let updateTime: String?

    private enum RootKey: String, CodingKey {
        case fields
        case name, updateTime, createTime
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

    private enum MessageCodingKey: String, CodingKey {
        case mapValue
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try rootContainer.nestedContainer(keyedBy: FieldKey.self, forKey: .fields)
        let arrayContainer = try fieldContainer.nestedContainer(keyedBy: ArrayKey.self, forKey: .messages)
        let valueContaier = try arrayContainer.nestedContainer(keyedBy: ValuesKey.self, forKey: .arrayValue)
        var messagesArrayContainer = try valueContaier.nestedUnkeyedContainer(forKey: .values)
        var decodedMessages: [FireStoreMessage] = []
        while !messagesArrayContainer.isAtEnd {
            let messageContainer = try messagesArrayContainer.nestedContainer(keyedBy: MessageCodingKey.self)
            let message = try messageContainer.decode(FireStoreMessage.self, forKey: .mapValue)
            decodedMessages.append(message)
        }
        self.messages = decodedMessages
        self.name = try rootContainer.decodeIfPresent(String.self, forKey: .name)
        self.createTime = try rootContainer.decodeIfPresent(String.self, forKey: .createTime)
        self.updateTime = try rootContainer.decodeIfPresent(String.self, forKey: .updateTime)
    }

    func toEntity() -> [ChatMessage] {
        return messages.map { $0.toEntity() }
    }
}

struct FireStoreMessage: Codable {
    let role: StringValue
    let content: StringValue
    let createdAt: StringValue

    enum RootKey: String, CodingKey {
        case fields
    }

    enum FieldKeys: String, CodingKey {
        case role, content, createdAt
//        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.role = try fieldContainer.decode(StringValue.self, forKey: .role)
        self.content = try fieldContainer.decode(StringValue.self, forKey: .content)
        self.createdAt = try fieldContainer.decode(StringValue.self, forKey: .createdAt)
    }

    init(message: ChatMessage) {
        self.role = StringValue(value: message.role.rawValue)
        self.content = StringValue(value: message.content)
        self.createdAt = StringValue(value: message.createdAt ?? Date().toTimeStamp)
    }

    func toEntity() -> ChatMessage {
        return ChatMessage(
            role: ChatRole(rawValue: role.value)!,
            content: content.value,
            createdAt: createdAt.value
        )
    }
}
