//
//  FirebaseStorageType.swift
//  Robt
//
//  Created by hong on 2023/03/22.
//

import Foundation

struct StringValue: Codable {
    let value: String

    private enum CodingKeys: String, CodingKey {
        case value = "stringValue"
    }
}

struct IntegerValue: Codable {
    let value: String

    private enum CodingKeys: String, CodingKey {
        case value = "integerValue"
    }
}

struct BooleanValue: Codable {
    let value: Bool

    private enum CodingKeys: String, CodingKey {
        case value = "booleanValue"
    }
}

struct DoubleValue: Codable {
    let value: Double

    private enum CodingKeys: String, CodingKey {
        case value = "doubleValue"
    }
}

struct TimeStampValue: Codable {
    let value: String

    private enum CodingKeys: String, CodingKey {
        case value = "timestampValue"
    }
}

struct ArrayValue<T: Codable>: Codable {
    let arrayValue: [String: [T]]

    private enum CodingKeys: String, CodingKey {
        case arrayValue
    }

    init(values: [T]) {
        self.arrayValue = ["values": values]
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.arrayValue = try container.decode([String: [T]].self, forKey: .arrayValue)
    }
}

struct MapValue: Codable {
    let value: FieldValue

    private enum CodingKeys: String, CodingKey {
        case value = "mapValue"
    }

    init(value: FieldValue) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(FieldValue.self, forKey: .value)
    }
}

struct FieldValue: Codable {
    var fields: [String: StringValue]

    private enum CodingKeys: String, CodingKey {
        case fields
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fields = try container.decode([String: StringValue].self, forKey: .fields)
    }
}

struct DocumentsValue: Codable {
    var value: [FieldValue]

    private enum CodingKeys: String, CodingKey {
        case value = "documents"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode([FieldValue].self, forKey: .value)
    }
}

struct QueryResultValue<T: Codable>: Codable {
    let readTime: String
    let document: T

    private enum FieldKeys: String, CodingKey {
        case readTime, document
    }
}
