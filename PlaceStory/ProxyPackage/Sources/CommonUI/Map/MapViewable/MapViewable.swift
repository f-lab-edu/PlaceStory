//
//  File.swift
//  
//
//  Created by 최제환 on 1/31/24.
//

import Entities
import Foundation
import MapKit

public enum MapViewType {
    case apple
}

public protocol MapViewable where Self: UIView {
    func configureUI()
    func updateCurrentLocation()
    func updateSelectedLocation(from placeRecord: PlaceMark)
}

public protocol AppleMapViewable: MapViewable {
    var mapView: MKMapView { get }
    
    func setDelegate(_ delegate: AppleMapViewButtonDelegate)
    func getAnnotations() -> [MKAnnotation]
}
