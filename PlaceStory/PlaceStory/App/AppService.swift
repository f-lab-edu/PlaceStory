import Foundation
import UseCase
import UIKit

extension AppServiceUsecase {
  static let live = AppServiceUsecase(openSetting: {
    let settingURL = URL(string: UIApplication.openSettingsURLString)
    settingURL.map { UIApplication.shared.open($0) }
  })
}
