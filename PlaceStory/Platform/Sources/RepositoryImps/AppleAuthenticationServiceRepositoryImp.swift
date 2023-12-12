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
import Repositories

public final class AppleAuthenticationServiceRepositoryImp: NSObject, AppleAuthenticationServiceRepository {
    
    private let signInSubject = PassthroughSubject<AppleUser, Error>()
    
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
}

extension AppleAuthenticationServiceRepositoryImp: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInSubject.send(completion: .failure(error))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("CJHLOG: ‼️ Invalid state: A login callback was received, but no login request was sent.")
            return
        }
        
        var codeStr = ""
        if let code = appleIDCredential.authorizationCode {
            codeStr = String(data: code, encoding: .utf8) ?? ""
        }
        
        let user = appleIDCredential.user
        var email = appleIDCredential.email ?? ""
        let idToken = appleIDCredential.identityToken ?? Data()
        let idTokenToString = String(data: idToken, encoding: .utf8) ?? ""
        
        if email.isEmpty {
            let decodeResult = decodeWith(idToken: idTokenToString)
            print("CJHLOG: decodeResult = \(decodeResult)")
            email = decodeResult["email"] as? String ?? ""
        }
        
        let familyName = appleIDCredential.fullName?.familyName ?? ""
        let givenName = appleIDCredential.fullName?.givenName ?? ""
        let fullName = "\(familyName)\(givenName)"
        let imgPath = "https://appleid.apple.com\(idTokenToString)/picture"
        
        let appleUser = AppleUser(
            userIdentifier: user,
            email: email,
            name: fullName,
            accessToken: codeStr,
            identityToken: idTokenToString,
            imgPath: imgPath
        )
        
        signInSubject.send(appleUser)
        
        // Todo. Realm에 저장
    }
}
