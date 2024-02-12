import Foundation
import UseCase
import UIKit

extension AppSettingsServiceUseCase {
    static let live = AppSettingsServiceUseCase(openSetting: {
        let settingURL = URL(string: UIApplication.openSettingsURLString)
        settingURL.map { UIApplication.shared.open($0) }
    })
}
