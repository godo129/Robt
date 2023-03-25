//
//  AppleAuthenticationRepository.swift
//  Robt
//
//  Created by hong on 2023/03/15.
//

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
                        guard error != nil else {
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
