//
//  AppRootInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import Combine
import Foundation
import ModernRIBs
import Repositories
import UseCase
import Utils

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
    private let appleAuthenticationServiceRepository: AppleAuthenticationServiceRepository
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: AppRootPresentable,
        appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase,
        appleAuthenticationServiceRepository: AppleAuthenticationServiceRepository
    ) {
        self.appleAuthenticationServiceUseCase = appleAuthenticationServiceUseCase
        self.appleAuthenticationServiceRepository = appleAuthenticationServiceRepository
        self.cancellables = .init()
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        appleAuthenticationServiceUseCase.checkPreviousSignInWithApple()
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .failure(let error):
                    Log.error("error is \(error)", "[\(#file)-\(#function) - \(#line)]")
                    self.router?.attachLoggedOut()
                    
                case .finished:
                    break
                }
            } receiveValue: { [weak self] hasPrevious in
                guard let self else { return }
                
                if hasPrevious {
                    if let userInfo = self.appleAuthenticationServiceUseCase.fetchUserInfo() {
                        Log.info("UserInfo is \(userInfo)", "[\(#file)-\(#function) - \(#line)]")
                    }
                } else {
                    self.router?.attachLoggedOut()
                }
            }
            .store(in: &cancellables)

    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
