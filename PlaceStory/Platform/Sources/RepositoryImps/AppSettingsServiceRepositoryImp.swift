//
//  File.swift
//
//
//  Created by 최제환 on 2/8/24.
//

import Foundation
import Repositories
import UIKit

public protocol UIApplicationProtocol {
  func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

public final class AppSettingsServiceRepositoryImp {
  private let application: UIApplicationProtocol
  public init(application: UIApplicationProtocol) {
    self.application = application
  }
}

extension AppSettingsServiceRepositoryImp: AppSettingsServiceRepository {
  public func updateLocationPermissionInSettings() {
    guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
    
    if self.application.canOpenURL(settingURL) {
      self.application.open(settingURL, options: [:], completionHandler: nil)
    }
  }
}

extension UIApplication: UIApplicationProtocol {
  
}
