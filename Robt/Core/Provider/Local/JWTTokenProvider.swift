//
//  JWTTokenProvider.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import CryptoKit
import Foundation
import SwiftJWT

struct JWTTokenProvider {

    private var currentTime: Int {
        return Int(Date().timeIntervalSince1970)
    }

    func header(alg: String, kid: String) -> String {
        // Header를 JSON으로 직렬화합니다.
        let header: [String: Any] = [
            "alg": alg,
            "kid": kid
        ]
        let headerData = try! JSONSerialization.data(withJSONObject: header)
        let encodedHeader = headerData.base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
        return encodedHeader
    }

    func payload(iss: String, expLimit: Int) -> String {
        // Payload를 JSON으로 직렬화합니다.
        let payload: [String: Any] = [
            "iss": iss,
            "iat": currentTime,
            "exp": currentTime + expLimit,
            "aud": "https://appleid.apple.com",
            "sub": Bundle.main.bundleIdentifier!
        ]
        let payloadData = try! JSONSerialization.data(withJSONObject: payload)
        let encodedPayload = payloadData.base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
        return encodedPayload
    }

    func signature(header: String, payload: String) -> String {
        // Header와 Payload를 '.'으로 구분하여 합칩니다.
        let unsignedToken = "\(header).\(payload)"

        // Secret Key로 HMAC SHA-256을 계산하여 Signature를 생성합니다.
        let secret = "secret"
        let hmac = HMAC<SHA256>.authenticationCode(for: Data(unsignedToken.utf8), using: SymmetricKey(data: Data(secret.utf8)))
        let signature = Data(hmac).base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
        return signature
    }

    func jwt(header: String, payload: String, signature: String) -> String {
        // Header, Payload, Signature를 '.'으로 구분하여 JWT를 생성합니다.
        let jwt = "\(header).\(payload).\(signature)"
        return jwt
    }

    func makeJWT() {}
}
