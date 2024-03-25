//
//  File.swift
//  
//
//  Created by 최제환 on 12/6/23.
//

import Combine
import Entities
import Foundation

public protocol AppleAuthenticationServiceRepository {
    func signIn() -> AnyPublisher<Bool, Error>
    func decodeWith(idToken: String) -> [String: Any]
    func fetchAppleSignInStatus() -> Future<Bool, Error>
    func fetchUserID() -> String?
}
