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

public protocol LocationServiceUseCase {
    func verifyLocationPermission() -> AnyPublisher<Bool, Never>
    func movedToUserLocation() -> AnyPublisher<CLLocation, Error>
    func stopLocationTracking()
}

public final class LocationServiceUseCaseImp: LocationServiceUseCase {
    private let locationServiceRepository: LocationServiceRepository
    
    public init(
        locationServiceRepository: LocationServiceRepository
    ) {
        self.locationServiceRepository = locationServiceRepository
    }
    
    public func verifyLocationPermission() -> AnyPublisher<Bool, Never> {
        locationServiceRepository.isLocationPermissionGranted()
    }
    
    public func movedToUserLocation() -> AnyPublisher<CLLocation, Error> {
        locationServiceRepository.publishCurrentLocation()
    }
    
    public func stopLocationTracking() {
        locationServiceRepository.stopLocationUpdates()
    }
}
