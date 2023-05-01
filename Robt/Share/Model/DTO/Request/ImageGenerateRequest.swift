//
//  ImageGenerateRequest.swift
//  Robt
//
//  Created by hong on 2023/05/01.
//

import Foundation

struct ImageGenerateRequest: Encodable {

    let prompt: String
    let numberOfPicture: Int = 1
    let size: ImageSize

    enum CodingKeys: String, CodingKey {
        case prompt, size
        case numberOfPicture = "n"
    }

    init(_ imageGenerate: ImageGenerate) {
        self.prompt = imageGenerate.prompt
        self.size = imageGenerate.imageSize
    }
}
