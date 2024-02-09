//
//  MyLocationViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import AppleMapView
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
    
    private lazy var placeSearchButton: UIButton = {
        let uiButton = UIButton()
        
        uiButton.setImage(
            UIImage(
                systemName: "magnifyingglass",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 14,
                    weight: .medium
                )
            ),
            for: .normal
        )
        uiButton.backgroundColor = .white
        uiButton.layer.borderWidth = 1.0
        uiButton.layer.borderColor = UIColor.black.cgColor
        uiButton.layer.cornerRadius = 10.0
        uiButton.tintColor = .black
        uiButton.addTarget(self, action: #selector(didTapPlaceSearcher), for: .touchUpInside)
        
        return uiButton
    }()
    
    private lazy var myLocationButton: UIButton = {
        let uiButton = UIButton()
        
        uiButton.setImage(
            UIImage(
                systemName: "location.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 14,
                    weight: .medium
                )
            ),
            for: .normal
        )
        uiButton.backgroundColor = .white
        uiButton.layer.borderWidth = 1.0
        uiButton.layer.borderColor = UIColor.black.cgColor
        uiButton.layer.cornerRadius = 10.0
        uiButton.tintColor = .black
        uiButton.addTarget(self, action: #selector(didTapMyLocation), for: .touchUpInside)
        
        return uiButton
    }()
    
    private let mapViewFactory: MapViewFactory
    
    weak var listener: MyLocationPresentableListener?
    private var placeMapView: MapViewable?
    
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
        view.addSubview(placeSearchButton)
        view.addSubview(myLocationButton)
        
        configureTabbarItem()
        configurePlaceMapViewConstraint()
        configurePlaceSearchButtonAutoLayout()
        configureMyLocationButtonAutoLayout()
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
    
    private func configurePlaceSearchButtonAutoLayout() {
        placeSearchButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(44)
        }
    }
    
    private func configureMyLocationButtonAutoLayout() {
        myLocationButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(44)
        }
    }
    
    @objc func didTapPlaceSearcher() {
        listener?.didTapPlaceSearchButton()
    }
    
    @objc func didTapMyLocation() {
        listener?.didTapMyLocationButton()
    }
    
    // MARK: - MyLocationPresentable
    
    func showAlertWithOneAction(_ title: String, _ message: String, _ handler: (() -> Void)?) {
        PlaceStoryAlert.showAlertWithOneAction(self, title, message, handler)
    }
    
    func showAlertWithTwoAction(_ title: String, _ message: String, _ okButtonTitle: String, _ okHandler: (() -> Void)?, _ cancelButtonTitle: String, _ cancelHandler: (() -> Void)?) {
        PlaceStoryAlert.showAlertWithTwoAction(self, title, message, okButtonTitle, okHandler, cancelButtonTitle, cancelHandler)
    }
    
    func updateCurrentLocation() {
        placeMapView?.updateCurrentLocation()
    }
    
    func updateSelectedLocation(from placeMark: PlaceMark) {
        placeMapView?.updateSelectedLocation(from: placeMark)
    }
    
    // MARK: - AppleMapViewButtonDelegate
    
    func didSelectAnnotationView() {
        listener?.didSelectAnnotationView()
    }
}
