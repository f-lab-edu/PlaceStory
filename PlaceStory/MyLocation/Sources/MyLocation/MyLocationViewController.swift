//
//  MyLocationViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import CommonUI
import Entities
import ModernRIBs
import SnapKit
import UIKit

protocol MyLocationPresentableListener: AnyObject {
  func checkPermissionLocation()
  func didTapMyLocationButton()
  func didTapPlaceSearchButton()
  func didSelectAnnotationView()
}

final class MyLocationViewController: UIViewController, MyLocationPresentable, MyLocationViewControllable, MapViewDelegate {
  
  weak var listener: MyLocationPresentableListener?
  
  private var placeMapView: MapViewable?
  
  //  let mapViewFactory = MapViewFactoryImp()
  //  let mapView = mapViewFactory.makeMapView()
  //  mapView.setDelegate(self)
  //
  //  return mapView
  
  private let mapViewFactory: MapViewFactory
  
  init(mapViewFactory: MapViewFactory) {
    self.mapViewFactory = mapViewFactory
    super.init(nibName: nil, bundle: nil)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    listener?.checkPermissionLocation()
  }
  
  private func configureUI() {
    view.backgroundColor = .systemBackground
    title = "장소 검색"
    
    let mapView = self.mapViewFactory.makeMapView()
    self.placeMapView = mapView
    mapView.setDelegate(self)
    view.addSubview(mapView)
    
    configureTabbarItem()
    configurePlaceMapViewConstraint()
  }
  
  private func configureTabbarItem() {
    let defaultImage = UIImage(systemName: "map")
    let selectedImage = UIImage(systemName: "map.fill")
    tabBarItem = UITabBarItem(title: "장소 검색", image: defaultImage, selectedImage: selectedImage)
  }
  
  private func configurePlaceMapViewConstraint() {
    placeMapView?.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - MyLocationPresentable
  
  func showRequestLocationAlert(confirmHandler: @escaping (UIAlertAction) -> Void) {
    PlaceStoryAlert.showAlertWithTwoAction(
      self,
      "위치 권한 허용",
      "이 앱은 사용자의 현재 위치를 파악하여 지도에 표시하고, 사용자가 기록한 장소에 마커를 표시하는 기능을 제공합니다.\n이 기능을 사용하려면 위치 정보 접근 권한이 필요합니다.\n\'설정\'으로 이동하여 위치 권한을 허용해주시기 바랍니다.",
      "설정으로 이동",
      confirmHandler,
      "나중에 하기",
      nil
    )
  }
  
  func showFailedLocationAlert(_ error: Error) {
    PlaceStoryAlert.showAlertWithOneAction(
      self,
      "위치 불러오기",
      error.localizedDescription,
      nil
    )
  }
  
  func updateCurrentLocation() {
    placeMapView?.updateCurrentLocation()
  }
  
  func updateSelectedLocation(from placeRecord: PlaceRecord) {
    placeMapView?.updateSelectedLocation(from: placeRecord)
  }
  
  // MARK: - AppleMapViewButtonDelegate
  
  func didTapMyLocation() {
    listener?.didTapMyLocationButton()
  }
  
  func didTapPlaceSearch() {
    listener?.didTapPlaceSearchButton()
  }
  
  func didSelectAnnotationView() {
    listener?.didSelectAnnotationView()
  }
}
