//
//  DependencyKey.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import Foundation

struct DependencyKey: Hashable, Equatable {
    private let type: Any.Type
    private let name: String?
    
    init(
        type: Any.Type,
        name: String? = nil
    ) {
        self.type = type
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
        hasher.combine(name)
    }
    
    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return lhs.type == rhs.type
    }
}
