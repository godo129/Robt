//
//  AppleAuthenticationRepository.swift
//  Robt
//
//  Created by hong on 2023/03/15.
//

import Alamofire
import AuthenticationServices
import Foundation

protocol AppleAuthenticationRepositoryProtocol {
    func isSignIn() async throws -> Bool
    func viewControllerSetting(_ viewController: UIViewController)
    func signUp() async throws -> String
    func signIn() async throws -> String
}

final class AppleAuthenticationRepository: NSObject, AppleAuthenticationRepositoryProtocol {

    enum AppleAuthenticationError: Error {
        case unKnown
        case signUpError
        case signUpRevoke
        case signUpNotFound
        case signInError
    }

    private let appleProvider: ASAuthorizationAppleIDProvider
    private let keychainProvider: KeychainProviderProtocol
    private var continuation: CheckedContinuation<String, Error>?

    weak var viewController: UIViewController?

    init(
        appleProvider: ASAuthorizationAppleIDProvider,
        keychainProvider: KeychainProviderProtocol
    ) {
        self.appleProvider = appleProvider
        self.keychainProvider = keychainProvider
    }

    func viewControllerSetting(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func isSignIn() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let userID = try await keychainProvider.read(item: .appleAccount())
                    let result = await signInCheck(userID: userID)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func signInCheck(userID: String) async -> Bool {
        return await withUnsafeContinuation { continuation in
            appleProvider.getCredentialState(forUserID: userID) { credentialState, _ in
                switch credentialState {
                case .authorized:
                    continuation.resume(returning: true)
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }

    func signUp() async throws -> String {
        return try await withCheckedThrowingContinuation {
            continuation = $0
            let request = appleProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }

    func signIn() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let userID = try await keychainProvider.read(item: .appleAccount())
                    appleProvider.getCredentialState(forUserID: userID) { credentialState, error in
                        guard error == nil else {
                            continuation.resume(throwing: error ?? AppleAuthenticationError.signInError)
                            return
                        }
                        switch credentialState {
                        case .authorized:
                            continuation.resume(returning: userID)
                        case .revoked:
                            continuation.resume(throwing: AppleAuthenticationError.signUpRevoke)
                        case .notFound:
                            continuation.resume(throwing: AppleAuthenticationError.signUpNotFound)
                        default:
                            continuation.resume(throwing: AppleAuthenticationError.signUpError)
                        }
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension AppleAuthenticationRepository: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller _: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
//            let authorizationCode = appleIDCredential.identityToken!
//            let accessToken = String(data: authorizationCode, encoding: .utf8)!
//            print(accessToken)
//            let token = appleIDCredential.authorizationCode!
//            let refreshToken = String(data: token, encoding: .utf8)!
//            print(refreshToken)
//
//            let jwtProvider = JWTTokenProvider()
//            let header = jwtProvider.header(alg: "ES256", kid: "7QF4P98SP9")
//            let payload = jwtProvider.payload(iss: "KD3GVSQ9P4", expLimit: 20)
//            let signature = jwtProvider.signature(header: header, payload: payload)
//            let clientSecret = jwtProvider.jwt(header: header, payload: payload, signature: signature)
//            print(clientSecret)

            Task {
                do {
                    try await keychainProvider.delete(item: .appleAccount())
                } catch {
                    try await keychainProvider.save(item: .appleAccount(userIdentifier))
                    continuation?.resume(returning: userIdentifier)
                    continuation = nil
                }
                do {
                    try await keychainProvider.save(item: .appleAccount(userIdentifier))
                    continuation?.resume(returning: userIdentifier)
                    continuation = nil
                } catch {
                    continuation?.resume(throwing: error)
                    continuation = nil
                }
            }
        case let passwordCredential as ASPasswordCredential:
            let userName = passwordCredential.user
            let password = passwordCredential.password
            Task {
                do {
                    try await keychainProvider.delete(item: .appleAccount())
                } catch {
                    try await keychainProvider.save(item: .appleAccount(userName))
                    continuation?.resume(returning: userName)
                    continuation = nil
                }
                do {
                    try await keychainProvider.save(item: .appleAccount(userName))
                    continuation?.resume(returning: userName)
                    continuation = nil
                } catch {
                    continuation?.resume(throwing: error)
                    continuation = nil
                }
            }
        default:
            continuation?.resume(throwing: AppleAuthenticationError.unKnown)
            continuation = nil
        }
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }

    // MARK: - 애플 토큰 삭제 (탈퇴) HTTP 통신

    // Alamofire 라이브러리를 사용하였다.
    func revokeAppleToken(clientSecret: String, token: String, completionHandler: @escaping () -> Void) {
        let url = "https://appleid.apple.com/auth/revoke"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: Parameters = [
            "client_id": "com.godo.robt",
            "client_secret": clientSecret,
            "token": token
        ]

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   headers: header)
            .validate(statusCode: 200 ..< 600)
            .responseData { response in
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    print("애플 토큰 삭제 성공!")
                    completionHandler()
                }
            }
    }

    // SERVICE

    // MARK: - 애플 리프레시 토큰 발급

    func getAppleRefreshToken(code: String, completionHandler: @escaping (AppleTokenResponse) -> Void) {
        let url = "https://appleid.apple.com/auth/token"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: Parameters = [
            "client_id": "com.godo.robt",
            "client_secret": "1번의jwt토큰",
            "code": code,
            "grant_type": "authorization_code"
        ]

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   headers: header)
            .validate(statusCode: 200 ..< 600)
            .responseData { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    let responseData = data
                    print(responseData)

                    guard let output = try? JSONDecoder().decode(AppleTokenResponse.self, from: data) else {
                        print("Error: JSON Data Parsing failed")
                        return
                    }

                    completionHandler(output)
                case .failure:
                    print("애플 토큰 발급 실패 - \(response.error.debugDescription)")
                }
            }
    }
}

extension AppleAuthenticationRepository: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        print("viewcontroller 넘겨 받음")
        guard let window = viewController?.view.window else {
            fatalError("couldn't find window")
        }
        return window
    }
}

// MODEL

// MARK: - 애플 엑세스 토큰 발급 응답 모델

struct AppleTokenResponse: Codable {
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
