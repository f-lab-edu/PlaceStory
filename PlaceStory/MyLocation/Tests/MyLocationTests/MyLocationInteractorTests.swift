import Combine
import CommonUI
import CoreLocation
import Entities
import Repositories
import ModernRIBs
import UseCase
import XCTest
@testable import MyLocation

enum MyLocationErrorTest: Error {
    case failedmoveToUserLocationHandler
}

final class MyLocationInteractorTests: XCTestCase {

    var interactor: MyLocationInteractor!
    var locationServiceUseCase: LocationServiceUseCaseMock!
    var listener: MyLocationListenerMock!
    var viewController: MyLocationViewControllableMock!
    var router: MyLocationRoutingMock!
    
    override func setUp() {
        viewController = MyLocationViewControllableMock()
        locationServiceUseCase = LocationServiceUseCaseMock(repository: LocationServiceRepositoryMock())
        listener = MyLocationListenerMock()
        interactor = MyLocationInteractor(presenter: viewController, locationServiceUseCase: locationServiceUseCase)
        
        interactor.listener = listener
        viewController.listener = interactor
        
        router = MyLocationRoutingMock(interactable: interactor, viewControllable: viewController)
        interactor.router = router
        
        router.load()
        router.interactable.activate()
    }
    
    func test_verifyLocationPermission_failure() {
        // Given
        let verifyLocationPermissionHandler = {
            Just(false).eraseToAnyPublisher()
        }

        locationServiceUseCase.verifyLocationPermissionHandler = verifyLocationPermissionHandler
        
        // When
        viewController.listener?.checkPermissionLocation()
        
        // Then
        XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
        XCTAssertEqual(viewController.showRequestLocationAlertCallCount, 2)
    }
    
    func test_verifyLocationPermission_success() {
        // Given
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else { return }
        
        let isLocationPermissionGrantedHandler = {
            Just(true).eraseToAnyPublisher()
        }
        
        locationServiceRepositoryMock.isLocationPermissionGrantedHandler = isLocationPermissionGrantedHandler
        
        let movedToUserLocationHandler = {
            Future<CLLocation, Error>({ promise in
                promise(.success(CLLocation(latitude: 37.4114441, longitude: 127.0963892)))
            }).eraseToAnyPublisher()
        }
        locationServiceUseCase.movedToUserLocationHandler = movedToUserLocationHandler
        
        // When
        viewController.listener?.checkPermissionLocation()
        
        // Then
        XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
        XCTAssertEqual(locationServiceRepositoryMock.isLocationPermissionGrantedCallCount, 2)
        XCTAssertEqual(viewController.updateCurrentLocationCallCount, 1)
    }
    
    func test_updateCurrentUserLocation_failure() {
        // Given
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else { return }
        
        let isLocationPermissionGrantedHandler = {
            Just(true).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.isLocationPermissionGrantedHandler = isLocationPermissionGrantedHandler
        
        let publishCurrentLocationHandler = {
            Future<CLLocation, Error>({ promise in
                promise(.failure(MyLocationErrorTest.failedmoveToUserLocationHandler))
            }).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.publishCurrentLocationHandler = publishCurrentLocationHandler
        
        // When
        viewController.listener?.checkPermissionLocation()
        
        // Then
        XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
        XCTAssertEqual(locationServiceRepositoryMock.isLocationPermissionGrantedCallCount, 2)
        XCTAssertEqual(locationServiceUseCase.movedToUserLocationCallCount, 1)
        XCTAssertEqual(locationServiceRepositoryMock.publishCurrentLocationCallCount, 1)
        XCTAssertEqual(viewController.updateCurrentLocationCallCount, 0)
        XCTAssertEqual(viewController.showFailedLocationAlertCallCount, 1)
    }
    
    func test_updateCurrentUserLocation_success() {
        // Given
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else { return }
        
        let isLocationPermissionGrantedHandler = {
            Just(true).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.isLocationPermissionGrantedHandler = isLocationPermissionGrantedHandler
        
        let publishCurrentLocationHandler = {
            Future<CLLocation, Error>({ promise in
                promise(.success(CLLocation(latitude: 37.4114441, longitude: 127.0963892)))
            }).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.publishCurrentLocationHandler = publishCurrentLocationHandler
        
        // When
        viewController.listener?.checkPermissionLocation()
        
        // Then
        XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
        XCTAssertEqual(locationServiceRepositoryMock.isLocationPermissionGrantedCallCount, 2)
        XCTAssertEqual(viewController.updateCurrentLocationCallCount, 1)
        XCTAssertEqual(locationServiceUseCase.movedToUserLocationCallCount, 1)
        XCTAssertEqual(locationServiceRepositoryMock.publishCurrentLocationCallCount, 1)
        XCTAssertEqual(locationServiceUseCase.stopLocationTrackingCallCount, 1)
        XCTAssertEqual(locationServiceRepositoryMock.stopLocationUpdatesCallCount, 1)
    }
    
    func test_didTapPlaceSearchButton_failure() {
        //Given
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else { return }
        
        let isLocationPermissionGrantedHandler = {
            Just(true).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.isLocationPermissionGrantedHandler = isLocationPermissionGrantedHandler
        
        let publishCurrentLocationHandler = {
            Future<CLLocation, Error>({ promise in
                promise(.failure(MyLocationErrorTest.failedmoveToUserLocationHandler))
            }).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.publishCurrentLocationHandler = publishCurrentLocationHandler
        
        // When
        viewController.listener?.didTappedMyLocationButton()
        
        // Then
        XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
        XCTAssertEqual(locationServiceRepositoryMock.isLocationPermissionGrantedCallCount, 2)
        XCTAssertEqual(viewController.updateCurrentLocationCallCount, 0)
        XCTAssertEqual(locationServiceUseCase.movedToUserLocationCallCount, 1)
        XCTAssertEqual(locationServiceRepositoryMock.publishCurrentLocationCallCount, 1)
        XCTAssertEqual(viewController.showFailedLocationAlertCallCount, 1)
    }
    
    func test_didTapPlaceSearchButton_success() {
        // Given
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else { return }
        
        let isLocationPermissionGrantedHandler = {
            Just(true).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.isLocationPermissionGrantedHandler = isLocationPermissionGrantedHandler
        
        let publishCurrentLocationHandler = {
            Future<CLLocation, Error>({ promise in
                promise(.success(CLLocation(latitude: 37.4114441, longitude: 127.0963892)))
            }).eraseToAnyPublisher()
        }
        locationServiceRepositoryMock.publishCurrentLocationHandler = publishCurrentLocationHandler
        
        // When
        viewController.listener?.didTappedMyLocationButton()
        
        // Then
        XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
        XCTAssertEqual(locationServiceRepositoryMock.isLocationPermissionGrantedCallCount, 2)
        XCTAssertEqual(viewController.updateCurrentLocationCallCount, 1)
        XCTAssertEqual(locationServiceUseCase.movedToUserLocationCallCount, 1)
        XCTAssertEqual(locationServiceRepositoryMock.publishCurrentLocationCallCount, 1)
        XCTAssertEqual(locationServiceUseCase.stopLocationTrackingCallCount, 1)
        XCTAssertEqual(locationServiceRepositoryMock.stopLocationUpdatesCallCount, 1)
    }
}
