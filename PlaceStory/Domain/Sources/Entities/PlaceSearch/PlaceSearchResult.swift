//
//  File.swift
//  
//
//  Created by 최제환 on 1/10/24.
//

import Foundation
import MapKit

public struct PlaceSearchResult {
    public let results: [MKLocalSearchCompletion]
    
    public init(
        results: [MKLocalSearchCompletion]
    ) {
        self.results = results
    }
}
