//
//  LoggedOutInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import AuthenticationServices
import Combine
import ModernRIBs
import UseCase
import Utils

public protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    
    func showAlertWithOneAction(_ title: String,_ message: String,_ handler: (() -> Void)?)
}

public protocol LoggedOutListener: AnyObject {
    func detachLoggedOut()
}

protocol LoggedOutInteractorDependency {
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { get }
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    private let dependency: LoggedOutInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: LoggedOutPresentable,
        dependency: LoggedOutInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func handleSignInWithApple() {
        dependency.appleAuthenticationServiceUseCase.signInWithApple()
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    Log.debug("Finished.", "[\(#file)-\(#function) - \(#line)]")
                case let .failure(error):
                    Log.error("\(error.localizedDescription)", "[\(#file)-\(#function) - \(#line)]")
                    
                    self.presenter.showAlertWithOneAction("로그인", error.localizedDescription, nil)
                }
            } receiveValue: { [weak self] appleUser in
                guard let self else { return }
                
                Log.info("UserInfo is \(appleUser)", "[\(#file)-\(#function) - \(#line)]")
                self.listener?.detachLoggedOut()
            }
            .store(in: &cancellables)
    }
}
