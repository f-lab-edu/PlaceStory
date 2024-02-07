//
//  File.swift
//  
//
//  Created by 최제환 on 2/8/24.
//

import Foundation
import Repositories
import UIKit

public final class AppSettingsServiceRepositoryImp {
    public init() {}
}

extension AppSettingsServiceRepositoryImp: AppSettingsServiceRepository {
    public func updateLocationPermissionInSettings() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
}
