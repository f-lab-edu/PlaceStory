//
//  File.swift
//  
//
//  Created by 최제환 on 2/6/24.
//

import Combine
import Entities
import Foundation
import Repositories

public protocol PlaceListUsecase {
    func configureSelected(placeName: String)
    func searchPlaceName() -> String
    func searchPlaceRecordFrom() -> AnyPublisher<[PlaceRecord], Error>
    func add(placeRecord: PlaceRecord) -> Bool
    func modify(placeRecord: PlaceRecord) -> Bool
    func remove(placeRecord: PlaceRecord) -> Bool
}

public final class PlaceListUsecaseImp: PlaceListUsecase {
    
    private let placeListRepository: PlaceListRepository
    
    public init(
        placeListRepository: PlaceListRepository
    ) {
        self.placeListRepository = placeListRepository
    }
    
    public func configureSelected(placeName: String) {
        placeListRepository.saveSelected(placeName: placeName)
    }
    
    public func searchPlaceName() -> String {
        return placeListRepository.fetchPlaceName()
    }
    
    public func searchPlaceRecordFrom() -> AnyPublisher<[PlaceRecord], Error> {
        placeListRepository.fetchPlaceRecordFrom()
    }
    
    public func add(placeRecord: PlaceRecord) -> Bool {
        placeListRepository.insert(placeRecord: placeRecord)
    }
    
    public func modify(placeRecord: PlaceRecord) -> Bool {
        placeListRepository.update(placeRecord: placeRecord)
    }
    
    public func remove(placeRecord: PlaceRecord) -> Bool {
        placeListRepository.delete(placeRecord: placeRecord)
    }
}
