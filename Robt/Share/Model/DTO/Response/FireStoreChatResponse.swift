//
//  FireStoreChatResponse.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Foundation

struct FireStoreChatResponse: Codable {
    let name: String?
    let fields: Fields
    let createTime: String?
    let updateTime: String?

    struct Fields: Codable {
        var messages: Messages?

        struct Messages: Codable {
            var arrayValue: ArrayValue?

            struct ArrayValue: Codable {
                var values: [Value]?

                struct Value: Codable {
                    let mapValue: FirStoreMessage?
                }
            }
        }
    }
}

struct FirStoreMessage: Codable {
    let role: StringValue
    let content: StringValue
    let createdAt: TimeStampValue

    enum RootKey: String, CodingKey {
        case fields
    }

    enum FieldKeys: String, CodingKey {
        case role, content
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.role = try fieldContainer.decode(StringValue.self, forKey: .role)
        self.content = try fieldContainer.decode(StringValue.self, forKey: .content)
        self.createdAt = try fieldContainer.decode(TimeStampValue.self, forKey: .createdAt)
    }

    init(message: ChatMessage, createAt: Date = .init()) {
        self.role = StringValue(value: message.role.rawValue)
        self.content = StringValue(value: message.content)
        self.createdAt = TimeStampValue(value: createAt.toTimeStamp)
    }

    func toEntity() -> ChatMessage {
        return ChatMessage(
            role: ChatRole(rawValue: role.value)!,
            content: content.value
        )
    }
}


