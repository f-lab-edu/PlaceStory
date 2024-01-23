//
//  File.swift
//
//
//  Created by 최제환 on 1/22/24.
//

import MapKit

public final class PlaceAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    public var imageName: String?
    
    public init(
        coordinate: CLLocationCoordinate2D,
        title: String?,
        subtitle: String?,
        imageName: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}
