//
//  MyLocationViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import CommonUI
import MapKit
import ModernRIBs
import SnapKit
import UIKit

protocol MyLocationPresentableListener: AnyObject {
    func checkPermissionLocation()
    func didTappedMyLocationButton()
    func didTappedPlaceSearchButton()
}

final class MyLocationViewController: UIViewController, MyLocationPresentable, MyLocationViewControllable {

    weak var listener: MyLocationPresentableListener?
    
    lazy var myPlaceMapView: MapView = {
        let mapView = MapView()
        mapView.myLocationButton.addTarget(self, action: #selector(didTappedMyLocationButton), for: .touchUpInside)
        mapView.placeSearchButton.addTarget(self, action: #selector(didTappedPlaceSearchButton), for: .touchUpInside)
        
        mapView.mapView.delegate = self
        
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listener?.checkPermissionLocation()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "장소 검색"
        
        view.addSubview(myPlaceMapView)
        
        configureTabbarItem()
        configureMyPlaceMapViewConstraint()
    }
    
    private func configureTabbarItem() {
        let defaultImage = UIImage(systemName: "map")
        let selectedImage = UIImage(systemName: "map.fill")
        tabBarItem = UITabBarItem(title: "장소 검색", image: defaultImage, selectedImage: selectedImage)
    }
    
    private func configureMyPlaceMapViewConstraint() {
        myPlaceMapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc
    private func didTappedMyLocationButton() {
        listener?.didTappedMyLocationButton()
    }
    
    @objc
    private func didTappedPlaceSearchButton() {
        listener?.didTappedPlaceSearchButton()
    }
    
    private func isDuplicateAnnotation(_ annotation: [MKAnnotation], _ currentLocation: CLLocationCoordinate2D) -> Bool {
        return annotation.contains { existingAnnotation in
            existingAnnotation.coordinate.latitude == currentLocation.latitude &&
            existingAnnotation.coordinate.longitude == currentLocation.longitude
        }
    }
    
    private func addAnotation(_ location: CLLocationCoordinate2D, _ locationTitle: String) {
        let annotations = myPlaceMapView.mapView.annotations
        
        guard !isDuplicateAnnotation(annotations, location) else { return }
        
        let placeAnnotation = PlaceAnnotation(
            title: locationTitle,
            coordinate: location
        )
        placeAnnotation.imageName = "pins"
        
        self.myPlaceMapView.mapView.addAnnotation(placeAnnotation)
    }
    
    private func configureAnnotationView(for annotation: PlaceAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return mapView.dequeueReusableAnnotationView(withIdentifier: PlaceAnnotationView.identifier, for: annotation)
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
    
    // MARK: - MyLocationPresentable
    
    func showRequestLocationAlert() {
        PlaceStoryAlert.showAlertWithTwoAction(
            self,
            "위치 권한 허용",
            "이 앱은 사용자의 현재 위치를 파악하여 지도에 표시하고, 사용자가 기록한 장소에 마커를 표시하는 기능을 제공합니다.\n이 기능을 사용하려면 위치 정보 접근 권한이 필요합니다.\n\'설정\'으로 이동하여 위치 권한을 허용해주시기 바랍니다.",
            "설정으로 이동",
            { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            },
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
    
    func updateCurrentLocation(with location: CLLocation) {
        myPlaceMapView.mapView.showsUserLocation = true
        myPlaceMapView.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func movedLocation(to cLLocation: CLLocation, _ locationTitle: String) {
        let location = CLLocationCoordinate2D(latitude: cLLocation.coordinate.latitude, longitude: cLLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        
        myPlaceMapView.mapView.setRegion(region, animated: true)
        
        addAnotation(location, locationTitle)
    }
}

extension MyLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let placeAnnotation = annotation as? PlaceAnnotation {
            annotationView = configureAnnotationView(for: placeAnnotation, on: mapView)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            guard let annotationView = view as? PlaceAnnotationView else { continue }
            
            animateAnnotationView(annotationView)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let placeAnnotation = view.annotation as? PlaceAnnotation {
            let clLocation = CLLocation(latitude: placeAnnotation.coordinate.latitude, longitude: placeAnnotation.coordinate.longitude)
            
            movedLocation(to: clLocation, placeAnnotation.title ?? "")
        }
    }
}
