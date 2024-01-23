//
//  File.swift
//  
//
//  Created by 최제환 on 1/23/24.
//

import Entities
import MapKit

public final class PlaceMapViewDelegateHelper: NSObject, MKMapViewDelegate {
    
    public var placeMapView: MKMapView?
    
    public func movedLocation(to coordinate: CLLocationCoordinate2D) {
        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        
        placeMapView?.setRegion(region, animated: true)
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
        
        guard let placeMapView else { return }
        
        if !isDuplicateAnnotation(placeMapView.annotations, coordinate) {
            let placeAnnotation = PlaceAnnotation(
                coordinate: coordinate,
                title: placeRecord.placeName,
                subtitle: "",
                imageName: "pins"
            )
            
            placeMapView.addAnnotation(placeAnnotation)
        }
    }
    
    private func animateAnnotationView(_ annotationView: MKAnnotationView) {
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
            
            animateAnnotationView(annotationView)
        }
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let placeAnnotation = view.annotation as? PlaceAnnotation {
            let coordinate = placeAnnotation.coordinate
            
            movedLocation(to: coordinate)
        }
    }
}
