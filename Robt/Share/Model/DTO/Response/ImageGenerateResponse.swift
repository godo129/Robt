//
//  ImageGenerateResponse.swift
//  Robt
//
//  Created by hong on 2023/05/01.
//

import Foundation

struct ImageGenerateResponse: Decodable {
    let created: Int
    let data: [ImageUrl]

    struct ImageUrl: Decodable {
        let url: String
    }
}
