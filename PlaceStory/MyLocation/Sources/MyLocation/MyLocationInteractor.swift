//
//  MyLocationInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import Combine
import UseCase
import ModernRIBs

public protocol MyLocationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MyLocationPresentable: Presentable {
    var listener: MyLocationPresentableListener? { get set }
    
    func showRequestLocationAlert()
}

public protocol MyLocationListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyLocationInteractor: PresentableInteractor<MyLocationPresentable>, MyLocationInteractable, MyLocationPresentableListener {

    weak var router: MyLocationRouting?
    weak var listener: MyLocationListener?

    private let locationServiceUseCase: LocationServiceUseCase
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: MyLocationPresentable,
        locationServiceUseCase: LocationServiceUseCase
    ) {
        self.locationServiceUseCase = locationServiceUseCase
        self.cancellables = .init()
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        checkAndHandleLocationPermission()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func checkPermissionLocation() {
        checkAndHandleLocationPermission()
    }
    
    private func checkAndHandleLocationPermission() {
        locationServiceUseCase.verifyLocationPermission()
            .sink { [weak self] isLocationPermissionGranted in
                guard let self else { return }
                
                if isLocationPermissionGranted {
                    print("위치 권한 허용 O")
                } else {
                    self.presenter.showRequestLocationAlert()
                }
            }
            .store(in: &cancellables)
    }
}
