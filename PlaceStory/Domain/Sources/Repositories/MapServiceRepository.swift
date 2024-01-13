//
//  File.swift
//  
//
//  Created by 최제환 on 1/9/24.
//

import Combine
import Entities
import Foundation

public protocol MapServiceRepository {
    func searchPlace(from text: String) -> AnyPublisher<[PlaceSearchResult], Never>
    func startSearchWithLocalSearchCompletion(at index: Int) -> AnyPublisher<PlaceRecord, Never>
}
