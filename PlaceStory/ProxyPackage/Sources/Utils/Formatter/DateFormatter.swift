//
//  File.swift
//  
//
//  Created by 최제환 on 2/27/24.
//

import Foundation

public struct Formatter {
    public static let recordDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
}
