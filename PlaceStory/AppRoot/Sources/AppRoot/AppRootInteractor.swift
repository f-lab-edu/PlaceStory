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
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: AppRootPresentable,
        appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase
    ) {
        self.appleAuthenticationServiceUseCase = appleAuthenticationServiceUseCase
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
                        
                        DispatchQueue.main.async {
                            self.router?.attachLoggedIn()
                        }
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
    
    func detachLoggedOut() {
        router?.detachLoggedOut()
    }
}
