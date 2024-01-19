//
//  MyLocationInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import CoreLocation
import Combine
import CommonUI
import Entities
import ModernRIBs
import UseCase
import Utils

public protocol MyLocationRouting: ViewableRouting {
    func attachPlaceSearcher()
    func detachPlaceSearcher()
}

protocol MyLocationPresentable: Presentable {
    var listener: MyLocationPresentableListener? { get set }
    
    func showRequestLocationAlert()
    func showFailedLocationAlert(_ error: Error)
    func updateCurrentLocation(with location: CLLocation)
    func movedLocation(to cLLocation: CLLocation, _ locationTitle: String)
    func addAnotation(_ location: (Double, Double), _ locationTitle: String)
}

public protocol MyLocationListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyLocationInteractor: PresentableInteractor<MyLocationPresentable>, MyLocationInteractable, MyLocationPresentableListener, ModalAdaptivePresentationControllerDelegate {

    weak var router: MyLocationRouting?
    weak var listener: MyLocationListener?

    private let locationServiceUseCase: LocationServiceUseCase
    
    private var cancellables: Set<AnyCancellable>
    var modalAdaptivePresentationControllerDelegateProxy: ModalAdaptivePresentationControllerDelegateProxy
    
    init(
        presenter: MyLocationPresentable,
        locationServiceUseCase: LocationServiceUseCase
    ) {
        self.locationServiceUseCase = locationServiceUseCase
        self.cancellables = .init()
        self.modalAdaptivePresentationControllerDelegateProxy = ModalAdaptivePresentationControllerDelegateProxy()
        
        super.init(presenter: presenter)
        presenter.listener = self
        modalAdaptivePresentationControllerDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        checkAndHandleLocationPermission()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func checkAndHandleLocationPermission() {
        locationServiceUseCase.verifyLocationPermission()
            .sink { [weak self] isLocationPermissionGranted in
                guard let self else { return }
                
                if isLocationPermissionGranted {
                    updateCurrentUserLocation()
                } else {
                    self.presenter.showRequestLocationAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateCurrentUserLocation() {
        self.locationServiceUseCase.movedToUserLocation()
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .failure(let error):
                    Log.error("error is \(error)", "[\(#file)-\(#function) - \(#line)]")
                    
                    self.presenter.showFailedLocationAlert(error)
                    
                case .finished:
                    break
                }
            } receiveValue: { [weak self] location in
                guard let self else { return }
                
                Log.info("[현재 위치] - (\(location.coordinate.latitude), \(location.coordinate.longitude))", "[\(#file)-\(#function) - \(#line)]")
                
                self.presenter.updateCurrentLocation(with: location)
                self.requestStopLocationUpdates()
            }
            .store(in: &cancellables)
    }
    
    private func requestStopLocationUpdates() {
        locationServiceUseCase.stopLocationTracking()
    }
    
    // MARK: - MyLocationPresentableListener
    
    func checkPermissionLocation() {
        checkAndHandleLocationPermission()
    }
    
    func didTappedMyLocationButton() {
        checkAndHandleLocationPermission()
    }
    
    func didTappedPlaceSearchButton() {
        router?.attachPlaceSearcher()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachPlaceSearcher()
    }
    
    func isDuplicateAnnotation(_ exsitingAnnotations: [PlaceAnnotation], _ currentLocation: (latitude: Double, longitude: Double), locationTitle: String) {
        let isDuplicateAnnotation = exsitingAnnotations.contains { existingAnnotation in
            existingAnnotation.coordinate.latitude == currentLocation.latitude &&
            existingAnnotation.coordinate.longitude == currentLocation.longitude
        }
        
        if !isDuplicateAnnotation {
            presenter.addAnotation(currentLocation, locationTitle)
        }
    }
    
    // MARK: - MyLocationInteractor
    func placeSearcherDidTapClose() {
        router?.detachPlaceSearcher()
    }
    
    func selectedLocation(_ placeRecord: PlaceRecord) {
        let cLLocation = CLLocation(latitude: placeRecord.latitude, longitude: placeRecord.longitude)
        presenter.movedLocation(to: cLLocation, placeRecord.placeName)
        router?.detachPlaceSearcher()
    }
}
