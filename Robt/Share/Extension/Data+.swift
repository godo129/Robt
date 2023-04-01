//
//  Data+.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Foundation

extension Data {
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        do {
            let data = try JSONDecoder().decode(type, from: self)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}
