//
//  File.swift
//  
//
//  Created by 최제환 on 2/6/24.
//

import Entities
import Foundation
import RealmSwift

public final class PlaceRecordInfo: Object {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var placeName: String
    @Persisted public var recordTitle: String
    @Persisted public var recordDescription: String
    @Persisted public var placeCategory: String
    @Persisted public var registerDate: Date
    @Persisted public var updateDate: Date
    @Persisted public var recordImages: List<Data>
}

extension PlaceRecordInfo {
    public func toDomain() -> PlaceRecord {
        return PlaceRecord(
            id: id.stringValue,
            placeName: placeName,
            recordTitle: recordTitle,
            recordDescription: recordDescription,
            placeCategory: placeCategory,
            registerDate: registerDate,
            updateDate: updateDate,
            recordImages: Array(recordImages)
        )
    }
}
