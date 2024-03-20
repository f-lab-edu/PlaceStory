//
//  File.swift
//  
//
//  Created by 최제환 on 3/19/24.
//

import Entities
import Foundation

struct PlaceRecordEditorViewModel {
    let placeImage: Data

    init(_ recordImage: RecordImage) {
        self.placeImage = recordImage.placeImage
    }
}
