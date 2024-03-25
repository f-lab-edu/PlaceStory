//
//  File.swift
//
//
//  Created by 최제환 on 12/6/23.
//

import AuthenticationServices
import Combine
import CryptoKit
import FirebaseAuth
import Foundation
import Repositories
import Utils

public final class AppleAuthenticationServiceRepositoryImp: NSObject {
    private let signInSubject = PassthroughSubject<Bool, Error>()
    
    fileprivate var currentNonce: String?
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private func signIn(with credential: AuthCredential) {
        Auth.auth().signIn(
            with: credential) { [weak self] authResult, error in
                guard let self else { return }
                
                if let error {
                    self.signInSubject.send(completion: .failure(error))
                } else {
                    self.signInSubject.send(true)
                }
            }
    }
}

extension AppleAuthenticationServiceRepositoryImp: AppleAuthenticationServiceRepository {
    public func signIn() -> AnyPublisher<Bool, Error> {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
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
            Auth.auth().currentUser?.uid != nil ? promise(.success(true)) : promise(.success(false))
        }
    }
    
    public func fetchUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
}

extension AppleAuthenticationServiceRepositoryImp: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInSubject.send(completion: .failure(error))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            Log.error("Cannnot find appleIDCredential", "[\(#file)-\(#function) - \(#line)]")
            return
        }
        
        guard let nonce = currentNonce else {
            Log.error("Invalid state: A login callback was received, but no login request was sent.", "[\(#file)-\(#function) - \(#line)]")
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            Log.error("Unable to fetch identity token", "[\(#file)-\(#function) - \(#line)]")
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            Log.error("Unalbe to serialize token string from data: \(appleIDToken.debugDescription)", "[\(#file)-\(#function) - \(#line)]")
            return
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        signIn(with: credential)
    }
}

extension AppleAuthenticationServiceRepositoryImp: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let keyWindow = windowScene.keyWindow {
            return keyWindow
        } else {
            return UIWindow()
        }
    }
}
