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
import RealmSwift
import Repositories
import SecurityServices
import Utils

public final class AppleAuthenticationServiceRepositoryImp: NSObject {
    private let signInSubject = PassthroughSubject<AppleUser, Error>()
    private let database: RealmDatabaseImp
    private let keychain: KeychainServiceImp
    
    public init(
        database: RealmDatabaseImp,
        keychain: KeychainServiceImp
    ) {
        self.database = database
        self.keychain = keychain
    }
    
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
    
    private func checkForDuplicate(of userInfo: UserInfo) -> UserInfo? {
        if let userInfo = database.read(UserInfo.self, forKey: userInfo.id) {
            return userInfo
        } else {
            return nil
        }
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
    
    public func fetchAppleSignInStatus() -> Future<Bool, Error> {
        return Future { promise in
            let readResult = self.keychain.read("userIdentifier")
            
            if let userIdentifier = readResult.readValue {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                Log.debug("userIdentifier = \(userIdentifier)", "[\(#file)-\(#function) - \(#line)]")
                appleIDProvider.getCredentialState(forUserID: userIdentifier) { credentialState, error in
                    if let error = error {
                        Log.error("error is \(error.localizedDescription)", "[\(#file)-\(#function) - \(#line)]")
                        promise(.failure(error))
                    } else {
                        Log.error("credentialState is \(credentialState)", "[\(#file)-\(#function) - \(#line)]")
                        switch credentialState {
                        case .revoked:
                            promise(.success(false))
                        case .authorized:
                            promise(.success(true))
                        case .notFound:
                            promise(.success(false))
                        case .transferred:
                            promise(.success(false))
                        @unknown default:
                            promise(.success(false))
                        }
                    }
                }
            } else {
                Log.error(readResult.resultMessage, "[\(#file)-\(#function) - \(#line)]")
                promise(.success(false))
            }
        }
    }
    
    public func fetchUserInfo() -> AppleUser? {
        let readResult = keychain.read("objectId")
        
        if let readValue = readResult.readValue {
            let objectId = try! ObjectId(string: readValue)
            
            guard let userInfo = database.read(UserInfo.self, forKey: objectId) else {
                return nil
            }
            
            return userInfo.toDomain()
        }
        
        return nil
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
        
        if let userInfo = checkForDuplicate(of: userInfo) {
            signInSubject.send(userInfo.toDomain())
        } else {
            database.create(userInfo)
            
            let createForUserIdentifierResult = keychain.create("userIdentifier", userInfo.userIdentifier)
            let createForObjectIdResult = keychain.create("objectId", userInfo.id.stringValue)
            
            if createForUserIdentifierResult.isSucceed &&
                createForObjectIdResult.isSucceed {
                Log.debug("Success - \(createForUserIdentifierResult.resultMessage), \(createForObjectIdResult.resultMessage)", "[\(#file)-\(#function) - \(#line)]")
            } else {
                Log.error("Failed - \(createForUserIdentifierResult.resultMessage), , \(createForObjectIdResult.resultMessage)", "[\(#file)-\(#function) - \(#line)]")
            }
            
            signInSubject.send(userInfo.toDomain())
        }
    }
}
