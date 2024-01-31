//
//  File.swift
//  
//
//  Created by 최제환 on 1/23/24.
//

import Entities
import MapKit

protocol AppleMapViewDelegate: AnyObject {
    func animateAnnotationView(_ annotationView: PlaceAnnotationView)
    func movedLocation(to coordinate: CLLocationCoordinate2D)
    func didSelectAnnotationView()
}

public final class AppleMapViewDelegateProxy: NSObject, MKMapViewDelegate {
    
    weak var delegate: AppleMapViewDelegate?
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let placeAnnotation = annotation as? PlaceAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PlaceAnnotationView.identifier, for: placeAnnotation)
        }
        
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            guard let annotationView = view as? PlaceAnnotationView else { continue }
            
            delegate?.animateAnnotationView(annotationView)
        }
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let placeAnnotation = view.annotation as? PlaceAnnotation {
            let coordinate = placeAnnotation.coordinate
            
            delegate?.movedLocation(to: coordinate)
            delegate?.didSelectAnnotationView()
            mapView.deselectAnnotation(view.annotation, animated: true)
        }
    }
}
