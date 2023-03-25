//
//  Encodable+.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Foundation

extension Encodable {
    var toJson: Data? {
        return try? JSONEncoder().encode(self)
    }
}
