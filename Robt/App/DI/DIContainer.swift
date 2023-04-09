//
//  DIContainer.swift
//  Robt
//
//  Created by hong on 2023/04/10.
//

import Foundation

@propertyWrapper
struct DIContainer<T> {
    let container = DependenciesContainer.share
    var wrappedValue: T {
        container.resolve(type)
    }

    let type: T.Type
    init(_ type: T.Type) {
        self.type = type
    }
}
