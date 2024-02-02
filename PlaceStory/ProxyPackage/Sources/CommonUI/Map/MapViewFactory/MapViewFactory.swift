//
//  File.swift
//  
//
//  Created by 최제환 on 1/31/24.
//

import Foundation

public protocol MapViewFactory {
    func makeMapView(of type: MapViewType) -> MapViewable
}

public final class MapViewFactoryImp: MapViewFactory {
    public init() {}
    
    public func makeMapView(of type: MapViewType) -> MapViewable {
        switch type {
        case .apple:
            return AppleMapView()
        }
    }
}
