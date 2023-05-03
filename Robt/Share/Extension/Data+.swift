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

    // TODO: 변경 필요
    static func audiomultipartFormData(audioURL: URL) -> Encodable? {

        guard let audioData = try? Data(contentsOf: audioURL) else {
            fatalError("audio doesn't find")
        }

        let boundary = "bbb1234"
        let audioFileName = audioURL.lastPathComponent
        let audioMimeType = "audio/*"
        let audioDataField = "file"
        var audioDataPayload = "--\(boundary)\r\n"
        audioDataPayload += "Content-Disposition: form-data; name=\"\(audioDataField)\"; filename=\"\(audioFileName)\"\r\n"
        audioDataPayload += "Content-Type: \(audioMimeType)\r\n\r\n"
        audioDataPayload += "\(audioData)\r\n"

        let modelFieldName = "model"
        let modelName = "whisper-1"
        var modelPayload = "--\(boundary)\r\n"
        modelPayload += "Content-Disposition: form-data; name=\"\(modelFieldName)\"\r\n\r\n"
        modelPayload += "\(modelName)\r\n"

        let payload = audioDataPayload + modelPayload + "--\(boundary)--\r\n"
        let data = payload.data(using: .utf8)
        return data
    }
}
