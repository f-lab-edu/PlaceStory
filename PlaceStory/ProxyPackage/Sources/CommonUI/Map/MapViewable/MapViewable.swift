//
//  File.swift
//  
//
//  Created by 최제환 on 1/31/24.
//

import Entities
import Foundation
import UIKit

public protocol MapViewable where Self: UIView {
    func updateCurrentLocation()
    func updateSelectedLocation(from placeRecord: PlaceRecord)
    func setDelegate(_ delegate: MapViewDelegate)
}

public protocol MapViewDelegate: AnyObject {
    func didSelectAnnotationView()
}
