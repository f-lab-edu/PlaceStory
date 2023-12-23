//
//  LoggedInInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import ModernRIBs

public protocol LoggedInRouting: ViewableRouting {
    func attachTabs()
}

protocol LoggedInPresentable: Presentable {
    var listener: LoggedInPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol LoggedInListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LoggedInInteractor: PresentableInteractor<LoggedInPresentable>, LoggedInInteractable, LoggedInPresentableListener {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: LoggedInPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTabs()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
