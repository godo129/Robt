//
//  FireStoreChatRequest.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Foundation

struct FireStoreChatRequest: Encodable {
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

    private enum MessageCodingKey: String, CodingKey {
        case mapValue
    }

    func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = rootContainer.nestedContainer(keyedBy: FieldKey.self, forKey: .fields)
        var arrayContainer = fieldContainer.nestedContainer(keyedBy: ArrayKey.self, forKey: .messages)
        var valueContaier = arrayContainer.nestedContainer(keyedBy: ValuesKey.self, forKey: .arrayValue)
        var messagesArrayContainer = valueContaier.nestedUnkeyedContainer(forKey: .values)
        for message in messages {
            var messageContainer = messagesArrayContainer.nestedContainer(keyedBy: MessageCodingKey.self)
            var fieldContainer = messageContainer.nestedContainer(keyedBy: RootKey.self, forKey: .mapValue)
            try message.encode(to: fieldContainer.superEncoder(forKey: .fields))
        }
    }

    init(_ message: [ChatMessage]) {
        self.messages = message.map { FireStoreMessage(message: $0) }
    }
}
