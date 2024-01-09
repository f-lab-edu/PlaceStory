//
//  File.swift
//  
//
//  Created by 최제환 on 1/9/24.
//

import Combine
import Foundation
import MapKit
import Repositories

public protocol MapServiceUseCase {
    func updateSearchText(_ text: String) -> AnyPublisher<[MKLocalSearchCompletion], Never>
    func selectedLocation(at index: Int) -> AnyPublisher<(CLLocation, String), Never>
}

public final class MapServiceUseCaseImp: MapServiceUseCase {
    
    private let mapServiceRepository: MapServiceRepository
    
    public init(
        mapServiceRepository: MapServiceRepository
    ) {
        self.mapServiceRepository = mapServiceRepository
    }
    
    public func updateSearchText(_ text: String) -> AnyPublisher<[MKLocalSearchCompletion], Never> {
        mapServiceRepository.searchPlace(from: text)
    }
    
    public func selectedLocation(at index: Int) -> AnyPublisher<(CLLocation, String), Never> {
        mapServiceRepository.startSearchWithLocalSearchCompletion(at: index)
    }
}
