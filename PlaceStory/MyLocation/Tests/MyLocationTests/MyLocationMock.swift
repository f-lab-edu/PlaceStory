//
//  File.swift
//
//
//  Created by 최제환 on 1/11/24.
//

import Combine
import CommonUI
import CoreLocation
import Entities
import Foundation
import Repositories
import ModernRIBs
import UseCase
import UIKit
@testable import MyLocation

// MARK: - MyLocationBuildable Mock

final class MyLocationBuildableMock: MyLocationBuildable {
    var buildHandler: ((_ listener: MyLocationListener) -> MyLocationRouting)?
    var buildCallCount: Int = 0
    
    init() {}
    
    func build(withListener listener: MyLocationListener) -> MyLocationRouting {
        buildCallCount += 1
        if let buildHandler {
            return buildHandler(listener)
        }
        
        fatalError("Function build returns a value that can't be handled with a default value and its handler must be set")
    }
}

final class MyLocationInteractableMock: MyLocationInteractable {
    
    var router: MyLocationRouting? { didSet { routerSetCallCount += 1 } }
    var routerSetCallCount = 0
    
    var listener: MyLocationListener? { didSet { listenerSetCallCount += 1 } }
    var listenerSetCallCount = 0
    
    var isActive: Bool = false { didSet { isActiveSetCallCount += 1 } }
    var isActiveSetCallCount = 0
    
    var isActiveStreamSubject: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>() { didSet { isActiveStreamSubjectSetCallCount += 1 } }
    var isActiveStreamSubjectSetCallCount = 0
    var isActiveStream: AnyPublisher<Bool, Never> { return isActiveStreamSubject.eraseToAnyPublisher() }
    
    var modalAdaptivePresentationControllerDelegateProxy = ModalAdaptivePresentationControllerDelegateProxy()
    
    var activateHandler: (() -> ())?
    var activateCallCount = 0
    
    var deactivateHandler: (() -> ())?
    var deactivateCallCount = 0
    
    var placeSearcherDidTapCloseHandler: (() -> ())?
    var placeSearcherDidTapCloseCallCount = 0
    
    var selectedLocation: ((_ placeRecord: PlaceRecord) -> ())?
    var selectedLocationCallCount = 0
    
    init() {}
    
    func activate() {
        activateCallCount += 1
        if let activateHandler {
            return activateHandler()
        }
    }
    
    func deactivate() {
        deactivateCallCount += 1
        if let deactivateHandler {
            return deactivateHandler()
        }
    }
    
    func placeSearcherDidTapClose() {
        placeSearcherDidTapCloseCallCount += 1
        if let placeSearcherDidTapCloseHandler {
            return placeSearcherDidTapCloseHandler()
        }
    }
    
    func selectedLocation(_ placeRecord: PlaceRecord) {
        placeSearcherDidTapCloseCallCount += 1
        if let placeSearcherDidTapCloseHandler {
            return placeSearcherDidTapCloseHandler()
        }
    }
}

final class MyLocationRoutingMock: MyLocationRouting {
    
    var viewControllable: ViewControllable
    
    var interactable: Interactable { didSet { interactableSetCallCount += 1 } }
    var interactableSetCallCount = 0
    
    var children: [Routing] = [Routing]() { didSet { childrenSetCallCount += 1 } }
    var childrenSetCallCount = 0
    
    var lifecycleSubject: PassthroughSubject<RouterLifecycle, Never> = PassthroughSubject<RouterLifecycle, Never>() { didSet { lifecycleSubjectSetCallCount += 1 } }
    var lifecycleSubjectSetCallCount = 0
    var lifecycle: AnyPublisher<RouterLifecycle, Never> { return lifecycleSubject.eraseToAnyPublisher() }
    
    var loadHandler: (() -> ())?
    var loadCallCount: Int = 0
    
    var attachChildHandler: ((_ child: Routing) -> ())?
    var attachChildCallCount = 0
    
    var detachChildHandler: ((_ child: Routing) -> ())?
    var detachChildCallCount = 0
    
    var attachPlaceSearcherHandler: (() -> ())?
    var attachPlaceSearcherCallCount = 0
    
    var detachPlaceSearcherHandler: (() -> ())?
    var detachPlaceSearcherCallCount = 0
    
    init(
        interactable: Interactable,
        viewControllable: ViewControllable
    ) {
        self.interactable = interactable
        self.viewControllable = viewControllable
    }
    
    func load() {
        loadCallCount += 1
        loadHandler?()
    }
    
    func attachChild(_ child: Routing) {
        attachChildCallCount += 1
        attachChildHandler?(child)
    }
    
    func detachChild(_ child: Routing) {
        detachChildCallCount += 1
        detachChildHandler?(child)
    }
    
    func attachPlaceSearcher() {
        attachPlaceSearcherCallCount += 1
        attachPlaceSearcherHandler?()
    }
    
    func detachPlaceSearcher() {
        detachPlaceSearcherCallCount += 1
        detachPlaceSearcherHandler?()
    }
}

final class MyLocationViewControllableMock: MyLocationViewControllable, MyLocationPresentable {
    var uiviewController: UIViewController = UIViewController() { didSet { uiviewControllerSetCallCount += 1 } }
    var uiviewControllerSetCallCount = 0
    
    var showRequestLocationAlertHandler: (() -> Void)?
    var showRequestLocationAlertCallCount = 0
    
    var showFailedLocationAlertHandler: ((_ error: Error) -> Void)?
    var showFailedLocationAlertCallCount = 0
    
    var updateCurrentLocationHandler: ((_ location: CLLocation) -> Void)?
    var updateCurrentLocationCallCount = 0
    
    var movedLocationHandler: ((_ cLLocation: CLLocation, _ locationTitle: String) -> Void)?
    var movedLocationCallCount = 0
    
    var listener: MyLocationPresentableListener?
    
    init() {}
    
    func showRequestLocationAlert() {
        showRequestLocationAlertCallCount += 1
        showRequestLocationAlertHandler?()
    }
    
    func showFailedLocationAlert(_ error: Error) {
        showFailedLocationAlertCallCount += 1
        showFailedLocationAlertHandler?(error)
    }
    
    func updateCurrentLocation(with location: CLLocation) {
        updateCurrentLocationCallCount += 1
        updateCurrentLocationHandler?(location)
    }
    
    func movedLocation(to cLLocation: CLLocation, _ locationTitle: String) {
        movedLocationCallCount += 1
        movedLocationHandler?(cLLocation, locationTitle)
    }
}


final class MyLocationListenerMock: MyLocationListener {
    
}

enum LocationError: Error {
    case failed
}

final class LocationServiceUseCaseMock: LocationServiceUseCase {
    var repository: LocationServiceRepository! { didSet { repositorySetCallCount += 1 } }
    var repositorySetCallCount = 0
    
    var verifyLocationPermissionHandler: (() -> AnyPublisher<Bool, Never>)?
    var verifyLocationPermissionCallCount = 0
    
    var movedToUserLocationHandler: (() -> AnyPublisher<CLLocation, Error>)?
    var movedToUserLocationCallCount = 0
    
    var stopLocationTrackingHandler: (() -> ())?
    var stopLocationTrackingCallCount = 0
    
    init(
        repository: LocationServiceRepository
    ) {
        self.repository = repository
    }
    
    func verifyLocationPermission() -> AnyPublisher<Bool, Never> {
        verifyLocationPermissionCallCount += 1
        return repository.isLocationPermissionGranted()
    }
    
    func movedToUserLocation() -> AnyPublisher<CLLocation, Error> {
        movedToUserLocationCallCount += 1
        return repository.publishCurrentLocation()
    }
    
    func stopLocationTracking() {
        stopLocationTrackingCallCount += 1
        return repository.stopLocationUpdates()
    }
}

final class LocationServiceRepositoryMock: LocationServiceRepository {
    
    var isLocationPermissionGrantedHandler: (() -> AnyPublisher<Bool, Never>)?
    var isLocationPermissionGrantedCallCount = 0
    
    var publishCurrentLocationHandler: (() -> AnyPublisher<CLLocation, Error>)?
    var publishCurrentLocationCallCount = 0
    
    var stopLocationUpdatesHandler: (() -> ())?
    var stopLocationUpdatesCallCount = 0
    
    func isLocationPermissionGranted() -> AnyPublisher<Bool, Never> {
        isLocationPermissionGrantedCallCount += 1
        return isLocationPermissionGrantedHandler?() ?? Just(false).eraseToAnyPublisher()
    }
    
    func publishCurrentLocation() -> AnyPublisher<CLLocation, Error> {
        publishCurrentLocationCallCount += 1
        return publishCurrentLocationHandler?() ?? Future<CLLocation, Error>({ promise in
            promise(.success(CLLocation(latitude: 37.4114441, longitude: 127.0963892)))
        }).eraseToAnyPublisher()
    }
    
    func stopLocationUpdates() {
        stopLocationUpdatesCallCount += 1
        stopLocationUpdatesHandler?()
    }
}
