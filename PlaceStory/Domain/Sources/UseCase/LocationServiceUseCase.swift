//
//  File.swift
//  
//
//  Created by 최제환 on 12/27/23.
//

import Combine
import Foundation
import Repositories

public protocol LocationServiceUseCase {
    func verifyLocationPermission() -> AnyPublisher<Bool, Never>
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
}
