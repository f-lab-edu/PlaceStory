//
//  File.swift
//  
//
//  Created by 최제환 on 12/27/23.
//

import Combine
import Foundation

public protocol LocationServiceRepository {
    func isLocationPermissionGranted() -> AnyPublisher<Bool, Never>
}
