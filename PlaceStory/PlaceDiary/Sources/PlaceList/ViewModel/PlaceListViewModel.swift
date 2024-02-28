//
//  File.swift
//  
//
//  Created by 최제환 on 2/27/24.
//

import Entities
import Foundation
import UIKit
import Utils

struct PlaceListViewModel {
    let placeName: String
    let placeRecordTitle: String
    let placeRecordContent: String
    let placeRecordDate: String
    var thumbnail: UIImage?
    
    init(_ placeRecord: PlaceRecord) {
        self.placeName = placeRecord.placeName
        self.placeRecordTitle = placeRecord.recordTitle
        self.placeRecordContent = placeRecord.recordDescription
        self.placeRecordDate = Self.getDateDescriptionWith(
            registerDate: placeRecord.registerDate,
            updateDate: placeRecord.updateDate
        )
        if let thubmnailImageData = placeRecord.recordImages?[0] {
            self.thumbnail = UIImage(data: thubmnailImageData)
        }
    }
    
    private static func getDateDescriptionWith(registerDate: Date, updateDate: Date) -> String {
        let compareDateResult = registerDate.compare(updateDate)
        var dateDescription = ""
        
        switch compareDateResult {
        case .orderedAscending:
            dateDescription = "\(Formatter.recordDateFormatter.string(from: updateDate)) (수정)"
            
        case .orderedDescending:
            break
            
        case .orderedSame:
            dateDescription = Formatter.recordDateFormatter.string(from: registerDate)
        }
        
        return dateDescription
    }
}
