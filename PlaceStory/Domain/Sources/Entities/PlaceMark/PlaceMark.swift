//
//  File.swift
//  
//
//  Created by 최제환 on 1/10/24.
//

import Foundation

public struct PlaceMark {
    public let latitude: Double
    public let longitude: Double
    public let placeName: String
    public let placeDescription: String
    
    public init(
        latitude: Double,
        longitude: Double,
        placeName: String,
        placeDescription: String
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
        self.placeDescription = placeDescription
    }
}
