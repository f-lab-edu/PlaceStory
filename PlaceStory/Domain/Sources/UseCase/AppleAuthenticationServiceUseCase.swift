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
    func signInWithApple() -> AnyPublisher<Bool, Error>
    func checkPreviousSignInWithApple() -> Future<Bool, Error>
    func fetchUserID() -> String?
}

public final class AppleAuthenticationServiceUseCaseImp: AppleAuthenticationServiceUseCase {
    
    private let appleAuthenticationServiceRepository: AppleAuthenticationServiceRepository
    
    public init(
        appleAuthenticationServiceRepository: AppleAuthenticationServiceRepository
    ) {
        self.appleAuthenticationServiceRepository = appleAuthenticationServiceRepository
    }
    
    public func signInWithApple() -> AnyPublisher<Bool, Error> {
        appleAuthenticationServiceRepository.signIn()
    }
    
    public func checkPreviousSignInWithApple() -> Future<Bool, Error> {
        appleAuthenticationServiceRepository.fetchAppleSignInStatus()
    }
    
    public func fetchUserID() -> String? {
        return appleAuthenticationServiceRepository.fetchUserID()
    }
}
