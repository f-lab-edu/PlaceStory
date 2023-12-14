//
//  File.swift
//
//
//  Created by 최제환 on 12/6/23.
//

import AuthenticationServices
import Combine
import Entities
import Foundation
import LocalStorage
import Model
import Repositories
import SecurityServices
import Utils

public final class AppleAuthenticationServiceRepositoryImp: NSObject {
    private let signInSubject = PassthroughSubject<AppleUser, Error>()
    
    private func fetchUserInfo(from credential: ASAuthorizationAppleIDCredential) -> UserInfo {
        var codeStr = ""
        if let code = credential.authorizationCode {
            codeStr = String(data: code, encoding: .utf8) ?? ""
        }
        
        let user = credential.user
        var email = credential.email ?? ""
        let idToken = credential.identityToken ?? Data()
        let idTokenToString = String(data: idToken, encoding: .utf8) ?? ""
        
        if email.isEmpty {
            let decodeResult = decodeWith(idToken: idTokenToString)
            Log.info("decodeResult = \(decodeResult)", "[\(#file)-\(#function) - \(#line)]")
            email = decodeResult["email"] as? String ?? ""
        }
        
        let familyName = credential.fullName?.familyName ?? ""
        let givenName = credential.fullName?.givenName ?? ""
        let fullName = "\(familyName)\(givenName)"
        
        let userInfo = UserInfo()
        userInfo.userIdentifier = user
        userInfo.email = email
        userInfo.name = fullName
        userInfo.accessToken = codeStr
        userInfo.identityToken = idTokenToString
        userInfo.imgPath = nil
        
        return userInfo
    }
}

extension AppleAuthenticationServiceRepositoryImp: AppleAuthenticationServiceRepository {
    public func signIn() -> AnyPublisher<AppleUser, Error> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
        
        return signInSubject.eraseToAnyPublisher()
    }
    
    public func decodeWith(idToken: String) -> [String: Any] {
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }
        
        func decodeToken(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }
            
            return payload
        }
        
        let segments = idToken.components(separatedBy: ".")
        return decodeToken(segments[1]) ?? [:]
    }
    
    public func fetchAppleSignInStatus(_ completionHandler: @escaping (Bool) -> Void) {
        let readResult = KeychainService.shared.read("userIdentifier")
        Log.info("readResult = \(readResult.readValue) / \(readResult.resultMessage)", "[\(#file)-\(#function) - \(#line)]")
        if let userIdentifier = readResult.readValue {
            Log.debug(readResult.resultMessage, "[\(#file)-\(#function) - \(#line)]")
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { credentialState, error in
                if let error {
                    Log.error("error is \(error.localizedDescription)", "[\(#file)-\(#function) - \(#line)]")
                    
                    completionHandler(false)
                } else {
                    switch credentialState {
                    case .revoked:
                        completionHandler(false)
                    case .authorized:
                        completionHandler(true)
                    case .notFound:
                        completionHandler(false)
                    case .transferred:
                        completionHandler(false)
                    @unknown default:
                        completionHandler(false)
                    }
                }
            }
        } else {
            Log.error(readResult.resultMessage, "[\(#file)-\(#function) - \(#line)]")
            
            completionHandler(false)
        }
    }
}

extension AppleAuthenticationServiceRepositoryImp: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInSubject.send(completion: .failure(error))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            Log.error("Invalid state: A login callback was received, but no login request was sent.", "[\(#file)-\(#function) - \(#line)]")
            return
        }
        
        let userInfo = fetchUserInfo(from: appleIDCredential)
        
        signInSubject.send(userInfo.toDomain())
        
        RealmDatabaseImp.shared.create(userInfo)
        
        let createResult = KeychainService.shared.create("userIdentifier", userInfo.userIdentifier)
        
        if createResult.isSucceed {
            Log.debug("Success - \(createResult.resultMessage)", "[\(#file)-\(#function) - \(#line)]")
        } else {
            Log.error("Failed - \(createResult.resultMessage)", "[\(#file)-\(#function) - \(#line)]")
        }
    }
}
