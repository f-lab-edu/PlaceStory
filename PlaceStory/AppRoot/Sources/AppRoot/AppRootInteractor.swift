//
//  AppRootInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import Foundation
import ModernRIBs
import UseCase
import Utils

public protocol AppRootRouting: ViewableRouting {
    func attachLoggedOut()
    func detachLoggedOut()
    func attachLoggedIn()
}

protocol AppRootPresentable: Presentable {
    var listener: AppRootPresentableListener? { get set }
}

public protocol AppRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener {

    weak var router: AppRootRouting?
    weak var listener: AppRootListener?
    
    private let appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase
    
    init(
        presenter: AppRootPresentable,
        appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase
    ) {
        self.appleAuthenticationServiceUseCase = appleAuthenticationServiceUseCase
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        appleAuthenticationServiceUseCase.checkPreviousSignInWithApple { [weak self] hasPreviousSignInWithApple in
            guard let self else { return }
            
            if hasPreviousSignInWithApple {
                if let userInfo = self.appleAuthenticationServiceUseCase.fetchUserInfo() {
                    Log.info("UserInfo is \(userInfo)", "[\(#file)-\(#function) - \(#line)]")
                    
                    DispatchQueue.main.async {
                        self.router?.attachLoggedIn()
                    }
                }
            } else {
                self.router?.attachLoggedOut()
            }
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func detachLoggedOut() {
        router?.detachLoggedOut()
    }
    
    func attachLoggedIn() {
        router?.attachLoggedIn()
    }
}
