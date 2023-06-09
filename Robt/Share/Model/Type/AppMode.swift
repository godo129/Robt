//
//  AppMode.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import Foundation

enum AppMode {
    case authentication
    case home

    var tag: Int {
        switch self {
        case .authentication:
            return 0
        case .home:
            return 1
        }
    }
}
