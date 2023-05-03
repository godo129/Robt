//
//  URL+.swift
//  Robt
//
//  Created by hong on 2023/05/03.
//

import Foundation

extension URL {
    var byte: Int? {
        guard let data = try? Data(contentsOf: self) else {
            return nil
        }
        return data.count
    }
}
