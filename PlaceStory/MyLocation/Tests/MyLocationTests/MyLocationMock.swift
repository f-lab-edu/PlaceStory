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

// MARK: - MyLocationInteractable Mock

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
    
    var selectedLocationHandler: ((_ placeMark: PlaceMark) -> ())?
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
    
    func selectedLocation(_ placeMark: PlaceMark) {
        selectedLocationCallCount += 1
        if let selectedLocationHandler {
            return selectedLocationHandler(placeMark)
        }
    }
}

// MARK: - MyLocationRouting Mock

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
    
    var attachPlaceListHandler: ((String) -> ())?
    var attachPlaceListCallCount = 0
    
    var detachPresentationControllerHandler: (() -> ())?
    var detachPresentationControllerCallCount = 0
    
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
    
    func attachPlaceList(_ placeName: String) {
        attachPlaceListCallCount += 1
        attachPlaceListHandler?(placeName)
    }
    
    func detachPresentationController() {
        detachPresentationControllerCallCount += 1
        detachPresentationControllerHandler?()
    }
}

// MARK: - MyLocationViewControllable Mock

final class MyLocationViewControllableMock: MyLocationViewControllable, MyLocationPresentable {
    var uiviewController: UIViewController = UIViewController() { didSet { uiviewControllerSetCallCount += 1 } }
    var uiviewControllerSetCallCount = 0
    
    var showAlertWithOneActionHandler: (() -> Void)?
    var showAlertWithOneActionCallCount = 0
    
    var updateCurrentLocationHandler: (() -> Void)?
    var updateCurrentLocationCallCount = 0
    
    var movedLocationHandler: ((_ cLLocation: CLLocation, _ locationTitle: String) -> Void)?
    var movedLocationCallCount = 0
    
    var updateSelectedLocationHandler: ((_ placeMark: PlaceMark) -> Void)?
    var updateSelectedLocationCallCount = 0
    
    var listener: MyLocationPresentableListener?
    
    init() {}
    
    func showAlertWithOneAction(_ title: String, _ message: String, _ handler: (() -> Void)?) {
        showAlertWithOneActionCallCount += 1
        showAlertWithOneActionHandler?()
    }
    
    func updateCurrentLocation() {
        updateCurrentLocationCallCount += 1
        updateCurrentLocationHandler?()
    }
    
    func movedLocation(to cLLocation: CLLocation, _ locationTitle: String) {
        movedLocationCallCount += 1
        movedLocationHandler?(cLLocation, locationTitle)
    }
    
    func updateSelectedLocation(from placeMark: PlaceMark) {
        updateSelectedLocationCallCount += 1
        updateSelectedLocationHandler?(placeMark)
    }
}

// MARK: - MyLocationListener Mock

final class MyLocationListenerMock: MyLocationListener {
    
}

// MARK: - MyLocationDependencyMock

final class MyLocationDependencyMock: MyLocationInteractorDependency {
    var locationServiceUseCase: LocationServiceUseCase = LocationServiceUseCaseMock(repository: LocationServiceRepositoryMock())
    
    var mapServiceUseCase: MapServiceUseCase = MapServiceUsecaseMock(repository: MapServiceRepositoryMock())
    
    var appSettingsServiceUseCase: AppSettingsServiceUseCase = AppSettingsServiceUseCase(openSetting: {})
}

// MARK: - LocationServiceUseCase Mock

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

// MARK: - LocationServiceRepository Mock

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

final class MapServiceUsecaseMock: MapServiceUseCase {
    var repository: MapServiceRepository! { didSet { repositorySetCallCount += 1 } }
    var repositorySetCallCount = 0
    
    var updateSearchTextHandler: ((String) -> AnyPublisher<[PlaceSearchResult], Never>)?
    var updateSearchTextCallCount = 0
    
    var selectedLocationHandler: ((Int) -> AnyPublisher<[PlaceSearchResult], Never>)?
    var selectedLocationCallCount = 0
    
    init(
        repository: MapServiceRepository
    ) {
        self.repository = repository
    }
    
    func updateSearchText(_ text: String) -> AnyPublisher<[PlaceSearchResult], Never> {
        updateSearchTextCallCount += 1
        return repository.searchPlace(from: text)
    }
    
    func selectedLocation(at index: Int) -> AnyPublisher<PlaceMark, Never> {
        selectedLocationCallCount += 1
        return repository.startSearchWithLocalSearchCompletion(at: index)
    }
}

// MARK: - MapServiceRepositoryMock

final class MapServiceRepositoryMock: MapServiceRepository {
    var searchPlaceHandler: (() -> AnyPublisher<[PlaceSearchResult], Never>)?
    var searchPlaceCallCount = 0
    
    var startSearchWithLocalSearchCompletionHandler: ((Int) -> AnyPublisher<PlaceMark, Never>)?
    var startSearchWithLocalSearchCompletionCallCount = 0
    
    func searchPlace(from text: String) -> AnyPublisher<[PlaceSearchResult], Never> {
        searchPlaceCallCount += 1
        return searchPlaceHandler?() ?? Future<[PlaceSearchResult], Never>({ promise in
            promise(.success([PlaceSearchResult(title: "", titleHighlightRanges: [], subtitle: "", subtitleHighlightRanges: [])]))
        }).eraseToAnyPublisher()
    }
    
    func startSearchWithLocalSearchCompletion(at index: Int) -> AnyPublisher<PlaceMark, Never> {
        startSearchWithLocalSearchCompletionCallCount += 1
        return startSearchWithLocalSearchCompletionHandler?(index) ?? Future<PlaceMark, Never>({ promise in
            promise(.success(PlaceMark(latitude: 37.4114441, longitude: 127.0963892, placeName: "핀교 글로벌비즈센터", placeDescription: "회사")))
        }).eraseToAnyPublisher()
    }
}
