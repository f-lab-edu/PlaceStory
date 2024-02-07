//
//  File.swift
//  
//
//  Created by 최제환 on 2/6/24.
//

import Combine
import Entities
import Foundation
import LocalStorage

public protocol PlaceListRepository {
    func fetchPlaceRecordFrom(userId: String, placeName: String) -> AnyPublisher<[PlaceRecord], RealmDatabaseError>
    func insert(placeRecord: PlaceRecord) -> Bool
    func update(placeRecord: PlaceRecord) -> Bool
    func delete(placeRecord: PlaceRecord) -> Bool
}
