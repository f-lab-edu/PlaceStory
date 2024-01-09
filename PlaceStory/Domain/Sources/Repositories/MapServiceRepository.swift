//
//  File.swift
//  
//
//  Created by 최제환 on 1/9/24.
//

import Combine
import Foundation
import MapKit

public protocol MapServiceRepository {
    func searchPlace(from text: String) -> AnyPublisher<[MKLocalSearchCompletion], Never>
    func startSearchWithLocalSearchCompletion(at index: Int) -> AnyPublisher<(CLLocation, String), Never>
}
