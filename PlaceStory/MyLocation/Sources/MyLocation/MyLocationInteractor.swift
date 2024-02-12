//
//  MyLocationInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import Combine
import CommonUI
import Entities
import ModernRIBs
import UseCase
import Utils

public protocol MyLocationRouting: ViewableRouting {
  func attachPlaceSearcher()
  func detachPlaceSearcher()
  func attachPlaceList()
  func detachPresentationController()
}

protocol MyLocationPresentable: Presentable {
  var listener: MyLocationPresentableListener? { get set }
  func showAlertWithOneAction(_ title: String,_ message: String,_ handler: (() -> Void)?)
  func updateCurrentLocation()
  func updateSelectedLocation(from placeMark: PlaceMark)
}

public protocol MyLocationListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MyLocationInteractorDependency {
  var locationServiceUseCase: LocationServiceUseCase { get }
  var mapServiceUseCase: MapServiceUseCase { get }
  var appSettingsServiceUseCase: AppSettingsServiceUseCase { get }
  var appService: AppServiceUsecase { get }
}

final class MyLocationInteractor: PresentableInteractor<MyLocationPresentable>, MyLocationInteractable, MyLocationPresentableListener, ModalAdaptivePresentationControllerDelegate {
  
//  private let locationServiceUseCase: LocationServiceUseCase
//  private let mapServiceUseCase: MapServiceUseCase
//  private let appSettingsServiceUseCase: AppSettingsServiceUseCase
//  private let appService: AppServiceUsecase
  private let dependency: MyLocationInteractorDependency
  
  let modalAdaptivePresentationControllerDelegateProxy: ModalAdaptivePresentationControllerDelegateProxy
  
  weak var router: MyLocationRouting?
  weak var listener: MyLocationListener?
  
  private var cancellables: Set<AnyCancellable>
  
  init(
    presenter: MyLocationPresentable,
    dependency: MyLocationInteractorDependency
  ) {
    self.dependency = dependency
//    self.locationServiceUseCase = locationServiceUseCase
//    self.mapServiceUseCase = mapServiceUseCase
//    self.appSettingsServiceUseCase = appSettingsServiceUseCase
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
          self.presenter.showAlertWithOneAction(
            "위치 권한 허용",
            "\'PlaceStory\'에서 현재 위치를 파악하고, 기록한 장소를 지도에 표시하기 위해 위치 권한이 필요합니다.\n'설정'으로 이동하여 위치 권한을 허용해주시기 바랍니다.") { [weak self] in
              guard let self else { return }
              
              self.appSettingsServiceUseCase.goToAllowLocationPermission()
              
              self.dependency.appService.openSetting()
            }
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
          
          self.presenter.showAlertWithOneAction(
            "위치 불러오기",
            error.localizedDescription, nil
          )
          
        case .finished:
          break
        }
      } receiveValue: { [weak self] location in
        guard let self else { return }
        
        Log.info("[현재 위치] - (\(location.coordinate.latitude), \(location.coordinate.longitude))", "[\(#file)-\(#function) - \(#line)]")
        
        self.presenter.updateCurrentLocation()
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
  
  func didTapMyLocationButton() {
    checkAndHandleLocationPermission()
  }
  
  func didTapPlaceSearchButton() {
    router?.attachPlaceSearcher()
  }
  
  func presentationControllerDidDismiss() {
    router?.detachPresentationController()
  }
  
  func didSelectAnnotationView() {
    router?.attachPlaceList()
  }
  
  // MARK: - MyLocationInteractor
  func placeSearcherDidTapClose() {
    router?.detachPlaceSearcher()
  }
  
  func selectedLocation(_ placeMark: PlaceMark) {
    presenter.updateSelectedLocation(from: placeMark)
    
    router?.detachPlaceSearcher()
  }
}
