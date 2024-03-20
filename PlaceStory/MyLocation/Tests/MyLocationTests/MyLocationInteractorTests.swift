import Combine
import CommonUI
import CoreLocation
import Entities
import PlaceSearcher
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
    var dependency: MyLocationDependencyMock!
    var listener: MyLocationListenerMock!
    var viewController: MyLocationViewControllableMock!
    var router: MyLocationRoutingMock!
    
    override func setUp() {
        viewController = MyLocationViewControllableMock()
        dependency = MyLocationDependencyMock()
        listener = MyLocationListenerMock()
        interactor = MyLocationInteractor(presenter: viewController, dependency: dependency)
        
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

        if let locationServiceUseCase = dependency.locationServiceUseCase as? LocationServiceUseCaseMock {
            locationServiceUseCase.verifyLocationPermissionHandler = verifyLocationPermissionHandler
            
            // When
            viewController.listener?.checkPermissionLocation()
            
            // Then
            XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
            XCTAssertEqual(viewController.showAlertWithOneActionCallCount, 2)
        } else {
            XCTFail("dependency.locationServiceUseCase is not an instance of LocationServiceUseCaseMock")
        }
    }
    
    func test_verifyLocationPermission_success() {
        // Given
        guard let locationServiceUseCase = dependency.locationServiceUseCase as? LocationServiceUseCaseMock else {
            XCTFail("dependency.locationServiceUseCase is not an instance of LocationServiceUseCaseMock")
            return
        }
        
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else {
            XCTFail("dependency.repository is not an instance of LocationServiceRepositoryMock")
            return
        }
        
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
        guard let locationServiceUseCase = dependency.locationServiceUseCase as? LocationServiceUseCaseMock else {
            XCTFail("dependency.locationServiceUseCase is not an instance of LocationServiceUseCaseMock")
            return
        }
        
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else {
            XCTFail("dependency.repository is not an instance of LocationServiceRepositoryMock")
            return
        }
        
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
        XCTAssertEqual(viewController.showAlertWithOneActionCallCount, 2)
    }
    
    func test_updateCurrentUserLocation_success() {
        // Given
        guard let locationServiceUseCase = dependency.locationServiceUseCase as? LocationServiceUseCaseMock else {
            XCTFail("dependency.locationServiceUseCase is not an instance of LocationServiceUseCaseMock")
            return
        }
        
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else {
            XCTFail("dependency.repository is not an instance of LocationServiceRepositoryMock")
            return
        }
        
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
        guard let locationServiceUseCase = dependency.locationServiceUseCase as? LocationServiceUseCaseMock else {
            XCTFail("dependency.locationServiceUseCase is not an instance of LocationServiceUseCaseMock")
            return
        }
        
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else {
            XCTFail("dependency.repository is not an instance of LocationServiceRepositoryMock")
            return
        }
        
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
        viewController.listener?.didTapMyLocationButton()
        
        // Then
        XCTAssertEqual(locationServiceUseCase.verifyLocationPermissionCallCount, 2)
        XCTAssertEqual(locationServiceRepositoryMock.isLocationPermissionGrantedCallCount, 2)
        XCTAssertEqual(viewController.updateCurrentLocationCallCount, 0)
        XCTAssertEqual(locationServiceUseCase.movedToUserLocationCallCount, 1)
        XCTAssertEqual(locationServiceRepositoryMock.publishCurrentLocationCallCount, 1)
        XCTAssertEqual(viewController.showAlertWithOneActionCallCount, 2)
    }
    
    func test_didTapPlaceSearchButton_success() {
        // Given
        guard let locationServiceUseCase = dependency.locationServiceUseCase as? LocationServiceUseCaseMock else {
            XCTFail("dependency.locationServiceUseCase is not an instance of LocationServiceUseCaseMock")
            return
        }
        
        guard let locationServiceRepositoryMock = locationServiceUseCase.repository as? LocationServiceRepositoryMock else {
            XCTFail("dependency.repository is not an instance of LocationServiceRepositoryMock")
            return
        }
        
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
        viewController.listener?.didTapMyLocationButton()
        
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

final class MyLocationRouterTests: XCTestCase {
    private var placeSearcherBuilder: PlaceSearcherBuildableMock!
    private var myLocationInteractor: MyLocationInteractableMock!
    private var placeListBuilder: PlaceListBuildableMock!
    private var myLocationRouter: MyLocationRouter!
    
    override func setUp() {
        placeSearcherBuilder = PlaceSearcherBuildableMock()
        myLocationInteractor = MyLocationInteractableMock()
        placeListBuilder = PlaceListBuildableMock()
        myLocationRouter = MyLocationRouter(
            interactor: myLocationInteractor,
            viewController: MyLocationViewControllableMock(),
            placeSearcherBuilder: placeSearcherBuilder, 
            placeListBuilder: placeListBuilder
        )
    }
    
    func test_attachPlaceSearcher() {
        // Given
        let placeSearcherRouter = PlaceSearcherRoutingMock(interactable: PlaceSearcherInteractableMock(), viewControllable: PlaceSearcherViewControllableMock())
        var assignedListener: PlaceSearcherListener? = nil
        let buildHandler = { (_ listener: PlaceSearcherListener) -> (PlaceSearcherRouting) in
            assignedListener = listener
            return placeSearcherRouter
          }
        placeSearcherBuilder.buildHandler = buildHandler
        
        // When
        myLocationRouter.attachPlaceSearcher()
        
        // Then
        XCTAssertTrue(assignedListener === myLocationInteractor)
        XCTAssertEqual(placeSearcherBuilder.buildCallCount, 1)
        XCTAssertEqual(placeSearcherRouter.loadCallCount, 1)
    }
    
    func test_detachPlaceSearch() {
        // Given
        let placeSearcherInteractable = PlaceSearcherInteractableMock()
        let placeSearcherViewControllable = PlaceSearcherViewControllableMock()
        let placeSearcherRouter = PlaceSearcherRoutingMock(interactable: placeSearcherInteractable, viewControllable: placeSearcherViewControllable)
        myLocationRouter.placeSearcherRouter = placeSearcherRouter
        
        // When
        myLocationRouter.detachPlaceSearcher()
        
        // Then
        XCTAssertNil(myLocationRouter.placeSearcherRouter)
        XCTAssertEqual(placeSearcherInteractable.deactivateCallCount, 1)
    }
}
