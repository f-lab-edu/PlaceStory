//
//  File.swift
//  
//
//  Created by 최제환 on 12/27/23.
//

import Foundation
import MapKit
import SnapKit
import UIKit

final class MapView: UIView {
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.identifier)
        
        return mapView
    }()
    
    lazy var placeSearchButton: UIButton = {
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
        
        return uiButton
    }()
    
    lazy var myLocationButton: UIButton = {
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
        
        return uiButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    private func configureUI() {
        self.addSubview(mapView)
        self.addSubview(placeSearchButton)
        self.addSubview(myLocationButton)
        
        configureMapViewConstraint()
        configurePlaceSearchButtonConstraint()
        configureMyLocationButtonConstraint()
    }
    
    private func configureMapViewConstraint() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configurePlaceSearchButtonConstraint() {
        placeSearchButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(44)
        }
    }
    
    private func configureMyLocationButtonConstraint() {
        myLocationButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(44)
        }
    }
}
