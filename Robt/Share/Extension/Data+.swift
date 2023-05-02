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

    static func multipartFormData(formData: [String: String]) -> Encodable {
        let boundary = UUID().uuidString
        var data = Data()
        for form in formData.enumerated() {
            data.append(Data("--\(boundary)\r\n".utf8))
            let key = form.element.key
            let value = form.element.value
            data.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            data.append(Data("\(value)\r\n".utf8))
        }
        data.append(Data("--\(boundary)\r\n".utf8))
        return data
    }
}
