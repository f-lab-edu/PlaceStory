//
//  PlaceListInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import ModernRIBs

public protocol PlaceListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PlaceListPresentable: Presentable {
    var listener: PlaceListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol PlaceListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PlaceListInteractor: PresentableInteractor<PlaceListPresentable>, PlaceListInteractable, PlaceListPresentableListener {

    weak var router: PlaceListRouting?
    weak var listener: PlaceListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PlaceListPresentable) {
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
}
