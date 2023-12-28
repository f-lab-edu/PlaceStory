//
//  MyLocationInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import Repositories
import ModernRIBs

public protocol MyLocationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MyLocationPresentable: Presentable {
    var listener: MyLocationPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol MyLocationListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyLocationInteractor: PresentableInteractor<MyLocationPresentable>, MyLocationInteractable, MyLocationPresentableListener {

    weak var router: MyLocationRouting?
    weak var listener: MyLocationListener?

    
    
    override init(presenter: MyLocationPresentable) {
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
    
    func checkPermissionLocation() {
        
    }
}
