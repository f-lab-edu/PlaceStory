//
//  File.swift
//  
//
//  Created by 최제환 on 3/20/24.
//

import Foundation

public struct RecordImage: Hashable {
    private let id: UUID = UUID()
    public let placeImage: Data
    
    public init(placeImage: Data) {
        self.placeImage = placeImage
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
