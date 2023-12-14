//
//  AppRootInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs
import UseCase

public protocol AppRootRouting: ViewableRouting {
    func attachLoggedOut()
}

protocol AppRootPresentable: Presentable {
    var listener: AppRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
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
                print("사용자 정보 가져오기!")
            } else {
                self.router?.attachLoggedOut()
            }
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
