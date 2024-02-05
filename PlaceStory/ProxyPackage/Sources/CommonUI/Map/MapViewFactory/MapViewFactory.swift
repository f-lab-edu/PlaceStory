//
//  File.swift
//  
//
//  Created by 최제환 on 1/31/24.
//

import Foundation

public protocol MapViewFactory {
    func makeMapView() -> MapViewable
}

public final class MapViewFactoryImp: MapViewFactory {
    public init() {}
    
    public func makeMapView() -> MapViewable {
      return AppleMapView()
    }
}
