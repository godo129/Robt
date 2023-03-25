//
//  DependenciesContainer.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import Foundation

final class DependenciesContainer {
    static let share = DependenciesContainer()
    private var dependencies: [DependencyKey: Any] = [:]

    private init() {}

    func register<T>(
        _ type: T.Type,
        impl: Any,
        name: String? = nil
    ) {
        let dependencyKey = DependencyKey(type: type, name: name)
        dependencies[dependencyKey] = impl
    }

    func resolve<T>(
        _ type: T.Type,
        name: String? = nil
    ) -> T {
        let dependencyKey = DependencyKey(type: type, name: name)
        if let dep = dependencies[dependencyKey] as? T {
            return dep
        } else {
            let protocolTypeName = NSString(string: "\(type)").components(separatedBy: ".").last!
            fatalError("\(protocolTypeName) 의 존재성을 해결할 수 없습니다. 해당 실행 클래스: \(protocolTypeName).")
        }
    }
}
