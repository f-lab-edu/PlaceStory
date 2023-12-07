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
    
    func showAppleLoginErrorAlert(_ error: Error)
}

public protocol LoggedOutListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    private let appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: LoggedOutPresentable,
        appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase
    ) {
        self.appleAuthenticationServiceUseCase = appleAuthenticationServiceUseCase
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
        appleAuthenticationServiceUseCase.signInWithApple()
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    Log.debug("Finished.", "[\(#function) - \(#line)]")
                case let .failure(error):
                    self.presenter.showAppleLoginErrorAlert(error)
                    Log.error("\(error.localizedDescription)", "[\(#function) - \(#line)]")
                }
            } receiveValue: { appleUser in
                print("appleUser is \(appleUser)")
            }
            .store(in: &cancellables)
    }
}
