//
//  LocationMarkerInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs

protocol LocationMarkerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LocationMarkerPresentable: Presentable {
    var listener: LocationMarkerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LocationMarkerListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LocationMarkerInteractor: PresentableInteractor<LocationMarkerPresentable>, LocationMarkerInteractable, LocationMarkerPresentableListener {

    weak var router: LocationMarkerRouting?
    weak var listener: LocationMarkerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: LocationMarkerPresentable) {
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
