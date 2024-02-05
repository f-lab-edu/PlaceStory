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

public protocol AppleMapViewButtonDelegate: AnyObject {
    func didSelectAnnotationView()
}

final class AppleMapView: UIView, MapViewable {
     let mapView: MKMapView = {
        let mkMapView = MKMapView()
        mkMapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.identifier)
        
        return mkMapView
    }()
    
    private let appleMapViewDelegateProxy: AppleMapViewDelegateProxy
    
    weak var delegate: MapViewDelegate?
    
    override init(frame: CGRect) {
        self.appleMapViewDelegateProxy = AppleMapViewDelegateProxy()
        super.init(frame: frame)
        
        appleMapViewDelegateProxy.delegate = self
        mapView.delegate = appleMapViewDelegateProxy
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(mapView)
        
        configureMapViewAutoLayout()
    }
    
    public func setDelegate(_ delegate: MapViewDelegate) {
        self.delegate = delegate
    }
    
    func getAnnotations() -> [MKAnnotation] {
        return mapView.annotations
    }
    
    public func updateCurrentLocation() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func updateSelectedLocation(from placeRecord: PlaceRecord) {
        let coordenate = CLLocationCoordinate2D(latitude: placeRecord.latitude, longitude: placeRecord.longitude)
        movedLocation(to: coordenate)
        addAnnotation(as: placeRecord)
    }
    
    private func configureMapViewAutoLayout() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func isDuplicateAnnotation(_ exsitingAnnotations: [MKAnnotation], _ currentLocation: CLLocationCoordinate2D) -> Bool {
        return  exsitingAnnotations.contains { existingAnnotation in
            existingAnnotation.coordinate.latitude == currentLocation.latitude &&
            existingAnnotation.coordinate.longitude == currentLocation.longitude
        }
    }
    
    public func addAnnotation(as placeRecord: PlaceRecord) {
        let latitude = placeRecord.latitude
        let longitude = placeRecord.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if !isDuplicateAnnotation(mapView.annotations, coordinate) {
            let placeAnnotation = PlaceAnnotation(
                coordinate: coordinate,
                title: placeRecord.placeName,
                subtitle: "",
                imageName: "pins"
            )
            
            mapView.addAnnotation(placeAnnotation)
        }
    }
}

// MARK: - AppleMapViewDelegate

extension AppleMapView: AppleMapViewDelegate {
    func animateAnnotationView(_ annotationView: PlaceAnnotationView) {
        let endFrame = annotationView.frame
        annotationView.frame = endFrame.offsetBy(dx: 0, dy: -500)
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0.1,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
            annotationView.frame = endFrame
        }, completion: nil)
    }
    
    public func movedLocation(to coordinate: CLLocationCoordinate2D) {
        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(region, animated: true)
    }
    
    func didSelectAnnotationView() {
        delegate?.didSelectAnnotationView()
    }
}
