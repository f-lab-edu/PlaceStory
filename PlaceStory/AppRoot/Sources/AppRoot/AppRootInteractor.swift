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
    func attachLoggedIn(with userID: String)
}

protocol AppRootPresentable: Presentable {
    var listener: AppRootPresentableListener? { get set }
}

public protocol AppRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol AppRootInteractorDependency {
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { get }
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener {
    
    weak var router: AppRootRouting?
    weak var listener: AppRootListener?
    
    private let dependency: AppRootInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: AppRootPresentable,
        dependency: AppRootInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.appleAuthenticationServiceUseCase.checkPreviousSignInWithApple()
            .receive(on: DispatchQueue.main)
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
                    self.router?.attachLoggedIn(with: dependency.appleAuthenticationServiceUseCase.fetchUserID() ?? "")   
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
