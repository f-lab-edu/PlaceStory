//
//  File.swift
//
//
//  Created by 최제환 on 2/8/24.
//

import Foundation

public struct AppSettingsServiceUseCase {
    public let openSetting: () -> Void
    
    public init(openSetting: @escaping () -> Void) {
        self.openSetting = openSetting
    }
}
