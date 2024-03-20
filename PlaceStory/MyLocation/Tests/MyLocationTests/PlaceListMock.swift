//
//  File.swift
//  
//
//  Created by 최제환 on 3/20/24.
//

import Foundation
@testable import PlaceList

// MARK: - PlaceSearcherBuildable Mock
final class PlaceListBuildableMock: PlaceListBuildable {
    
    var buildHandler:((_ listener: PlaceListListener, _ placeName: String) -> PlaceListRouting)?
    var buildCallCount = 0
    
    func build(withListener listener: PlaceListListener, placeName: String) -> PlaceListRouting {
        buildCallCount += 1
        if let buildHandler {
            return buildHandler(listener, placeName)
        }
        fatalError("Function build returns a value that can't be handled with a default value and its handler must be set")
    }
}
