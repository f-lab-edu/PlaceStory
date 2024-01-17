//
//  File.swift
//  
//
//  Created by 최제환 on 1/10/24.
//

import Foundation

public struct PlaceRecord {
    public let latitude: Double
    public let longitude: Double
    public let placeName: String
    public let placeDescription: String
    public let placeImages: [Data]
    
    public init(
        latitude: Double,
        longitude: Double,
        placeName: String,
        placeDescription: String,
        placeImages: [Data]
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
        self.placeDescription = placeDescription
        self.placeImages = placeImages
    }
}
