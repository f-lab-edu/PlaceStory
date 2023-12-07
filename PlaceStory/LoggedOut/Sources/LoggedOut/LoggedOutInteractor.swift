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

public protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    
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
                    print("Finished.")
                case let .failure(error):
                    print("[\(#function) / \(#line)] error - \(error.localizedDescription)")
                }
            } receiveValue: { appleUser in
                print("appleUser is \(appleUser)")
            }
            .store(in: &cancellables)
    }
}
