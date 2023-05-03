//
//  MultiPartProvider.swift
//  Robt
//
//  Created by hong on 2023/05/03.
//

import Alamofire

let url = "https://api.openai.com/v1/audio/transcriptions"
let headers: HTTPHeaders = ["Authorization": APIEnvironment.openAIAPIKey]
let parameters: [String: String] = ["model": "whisper-1"]

struct MultipartP
