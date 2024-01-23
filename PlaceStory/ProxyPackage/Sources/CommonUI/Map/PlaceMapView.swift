//
//  File.swift
//  
//
//  Created by 최제환 on 1/22/24.
//

import Entities
import Foundation
import MapKit
import SnapKit
import UIKit

public enum MapViewType {
    case apple
}

public protocol MapView where Self: UIView {
    func configureUI()
    func setDelegate(_ delegate: AppleMapViewButtonDelegate)
    func updateCurrentLocation()
    func updateSelectedLocation(from placeRecord: PlaceRecord)
}

public protocol AppleMapViewButtonDelegate: AnyObject {
    func didTapPlaceSearch()
    func didTapMyLocation()
}

final class AppleMapView: UIView, MapView {
    private let mapView: MKMapView = {
        let mkMapView = MKMapView()
        mkMapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.identifier)
        
        return mkMapView
    }()
    
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
    
    private let placeMapViewDelegateHelper: PlaceMapViewDelegateHelper
    
    weak var delegate: AppleMapViewButtonDelegate?
    
    override init(frame: CGRect) {
        self.placeMapViewDelegateHelper = PlaceMapViewDelegateHelper()
        super.init(frame: frame)
        
        mapView.delegate = placeMapViewDelegateHelper
        placeMapViewDelegateHelper.placeMapView = mapView
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(mapView)
        addSubview(placeSearchButton)
        addSubview(myLocationButton)
        
        configureMapViewAutoLayout()
        configurePlaceSearchButtonAutoLayout()
        configureMyLocationButtonAutoLayout()
    }
    
    public func setDelegate(_ delegate: AppleMapViewButtonDelegate) {
        self.delegate = delegate
    }
    
    public func updateCurrentLocation() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func updateSelectedLocation(from placeRecord: PlaceRecord) {
        let coordenate = CLLocationCoordinate2D(latitude: placeRecord.latitude, longitude: placeRecord.longitude)
        placeMapViewDelegateHelper.movedLocation(to: coordenate)
        placeMapViewDelegateHelper.addAnnotation(as: placeRecord)
    }
    
    private func configureMapViewAutoLayout() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configurePlaceSearchButtonAutoLayout() {
        placeSearchButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(44)
        }
    }
    
    private func configureMyLocationButtonAutoLayout() {
        myLocationButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(44)
        }
    }
    
    @objc func didTapPlaceSearcher() {
        delegate?.didTapPlaceSearch()
    }
    
    @objc func didTapMyLocation() {
        delegate?.didTapMyLocation()
    }
}

public protocol MapViewFactory {
    func makeMapView(of type: MapViewType) -> MapView
}

public final class MapViewFactoryImp: MapViewFactory {
    public init() {}
    
    public func makeMapView(of type: MapViewType) -> MapView {
        switch type {
        case .apple:
            return AppleMapView()
        }
    }
}

//public final class PlaceMapView: MKMapView {
//    public lazy var placeSearchButton: UIButton = {
//        let uiButton = UIButton()
//        uiButton.setImage(
//            UIImage(
//                systemName: "magnifyingglass",
//                withConfiguration: UIImage.SymbolConfiguration(
//                    pointSize: 14,
//                    weight: .medium
//                )
//            ),
//            for: .normal
//        )
//        uiButton.backgroundColor = .white
//        uiButton.layer.borderWidth = 1.0
//        uiButton.layer.borderColor = UIColor.black.cgColor
//        uiButton.layer.cornerRadius = 10.0
//        uiButton.tintColor = .black
//        
//        return uiButton
//    }()
//    
//    public lazy var myLocationButton: UIButton = {
//        let uiButton = UIButton()
//        uiButton.setImage(
//            UIImage(
//                systemName: "location.fill",
//                withConfiguration: UIImage.SymbolConfiguration(
//                    pointSize: 14,
//                    weight: .medium
//                )
//            ),
//            for: .normal
//        )
//        uiButton.backgroundColor = .white
//        uiButton.layer.borderWidth = 1.0
//        uiButton.layer.borderColor = UIColor.black.cgColor
//        uiButton.layer.cornerRadius = 10.0
//        uiButton.tintColor = .black
//        
//        return uiButton
//    }()
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        
//        configureUI()
//    }
//    
//    private func configureUI() {
//        self.addSubview(placeSearchButton)
//        self.addSubview(myLocationButton)
//        
//        configurePlaceSearchButtonConstraint()
//        configureMyLocationButtonConstraint()
//    }
//    
//    private func configurePlaceSearchButtonConstraint() {
//        placeSearchButton.snp.makeConstraints { make in
//            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
//            make.width.height.equalTo(44)
//        }
//    }
//    
//    private func configureMyLocationButtonConstraint() {
//        myLocationButton.snp.makeConstraints { make in
//            make.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
//            make.width.height.equalTo(44)
//        }
//    }
//}
