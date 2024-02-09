//
//  File.swift
//  
//
//  Created by 최제환 on 2/6/24.
//

import Foundation

public struct PlaceRecord: Identifiable {
    public let id: String
    public let userId: String
    public let placeName: String
    public let recordTitle: String
    public let recordDescription: String
    public let placeCategory: String
    public let registerDate: Date
    public let updateDate: Date
    public let recordImages: [Data]?
    
    public init(
        id: String,
        userId: String,
        placeName: String,
        recordTitle: String,
        recordDescription: String,
        placeCategory: String,
        registerDate: Date,
        updateDate: Date,
        recordImages: [Data]?
    ) {
        self.id = id
        self.userId = userId
        self.placeName = placeName
        self.recordTitle = recordTitle
        self.recordDescription = recordDescription
        self.placeCategory = placeCategory
        self.registerDate = registerDate
        self.updateDate = updateDate
        self.recordImages = recordImages
    }
}
