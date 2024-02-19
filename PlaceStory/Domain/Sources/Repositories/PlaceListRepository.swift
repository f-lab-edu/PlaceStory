//
//  File.swift
//  
//
//  Created by 최제환 on 2/6/24.
//

import Combine
import Entities
import Foundation

public protocol PlaceListRepository {
    func saveSelected(placeName: String)
    func fetchPlaceName() -> String
    func fetchPlaceRecordFrom() -> AnyPublisher<[PlaceRecord], Error>
    func insert(placeRecord: PlaceRecord) -> Bool
    func update(placeRecord: PlaceRecord) -> Bool
    func delete(placeRecord: PlaceRecord) -> Bool
}
