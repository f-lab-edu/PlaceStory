//
//  File.swift
//  
//
//  Created by 최제환 on 1/10/24.
//

import Foundation
import MapKit

public class PlaceSearchResult: NSObject {
    public let title: String
    public let titleHighlightRanges: [NSValue]
    public let subtitle: String
    public let subtitleHighlightRanges: [NSValue]
    
    public init(
        title: String,
        titleHighlightRanges: [NSValue],
        subtitle: String,
        subtitleHighlightRanges: [NSValue]
    ) {
        self.title = title
        self.titleHighlightRanges = titleHighlightRanges
        self.subtitle = subtitle
        self.subtitleHighlightRanges = subtitleHighlightRanges
    }
}
