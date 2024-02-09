//
//  File.swift
//  
//
//  Created by 최제환 on 2/8/24.
//

import Foundation
import Repositories

public protocol AppSettingsServiceUseCase {
    func goToAllowLocationPermission()
}

public final class AppSettingsServiceUseCaseImp: AppSettingsServiceUseCase {
    
    private let appSettingsServiceRepository: AppSettingsServiceRepository
    
    public init(
        appSettingsServiceRepository: AppSettingsServiceRepository
    ) {
        self.appSettingsServiceRepository = appSettingsServiceRepository
    }
    
    public func goToAllowLocationPermission() {
        appSettingsServiceRepository.updateLocationPermissionInSettings()
    }
}
