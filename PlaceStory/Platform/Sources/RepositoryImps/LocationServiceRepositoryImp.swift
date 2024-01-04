//
//  File.swift
//  
//
//  Created by 최제환 on 12/27/23.
//

import CoreLocation
import Combine
import Foundation
import Repositories

public final class LocationServiceRepositoryImp: NSObject {
    private let locationManager: CLLocationManager
    private let authorizationStatusSubject = PassthroughSubject<Bool, Never>()
    private let updateLocationSubject = PassthroughSubject<CLLocation, Error>()
    
    public override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
    }
    
    private func checkCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted: // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            authorizationStatusSubject.send(false)
            
        case .authorizedAlways, .authorizedWhenInUse: // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            authorizationStatusSubject.send(true)
            locationManager.startUpdatingLocation()
            
        @unknown default:
            authorizationStatusSubject.send(false)
        }
    }
}

// MARK: - LocationServiceRepository
extension LocationServiceRepositoryImp: LocationServiceRepository {
    public func isLocationPermissionGranted() -> AnyPublisher<Bool, Never> {
        let authorizationStatus: CLAuthorizationStatus = locationManager.authorizationStatus
        
        checkCurrentLocationAuthorization(authorizationStatus)
        
        return authorizationStatusSubject.eraseToAnyPublisher()
    }
    
    public func publishCurrentLocation() -> AnyPublisher<CLLocation, Error> {
        return updateLocationSubject.eraseToAnyPublisher()
    }
    
    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationServiceRepositoryImp: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        checkCurrentLocationAuthorization(authorizationStatus)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            updateLocationSubject.send(location)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationSubject.send(completion: .failure(error))
    }
}
