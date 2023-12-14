//
//  File.swift
//  
//
//  Created by 최제환 on 12/5/23.
//

import Combine
import Entities
import Foundation
import Repositories

public protocol AppleAuthenticationServiceUseCase {
    func signInWithApple() -> AnyPublisher<AppleUser, Error>
    func checkPreviousSignInWithApple(_ completionHandler: @escaping (Bool) -> Void)
}

public final class AppleAuthenticationServiceUseCaseImp: AppleAuthenticationServiceUseCase {
    
    private let appleAuthenticationServiceRepository: AppleAuthenticationServiceRepository
    
    public init(
        appleAuthenticationServiceRepository: AppleAuthenticationServiceRepository
    ) {
        self.appleAuthenticationServiceRepository = appleAuthenticationServiceRepository
    }
    
    public func signInWithApple() -> AnyPublisher<AppleUser, Error> {
        appleAuthenticationServiceRepository.signIn()
    }
    
    public func checkPreviousSignInWithApple(_ completionHandler: @escaping (Bool) -> Void) {
        appleAuthenticationServiceRepository.fetchAppleSignInStatus { hasPreviousSignInWithApple in
            completionHandler(hasPreviousSignInWithApple)
        }
    }
}
