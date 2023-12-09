//
//  File.swift
//  
//
//  Created by 최제환 on 12/7/23.
//

import Foundation
import UIKit

public final class PlaceStoryAlert {
    public static func showAlertWithOneAction(
        _ viewController: UIViewController,
        _ title: String,
        _ message: String,
        _ handler: ((UIAlertAction) -> ())?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "확인", style: .cancel,
            handler: handler
        )
        
        alertController.addAction(action)
        
        viewController.present(
            alertController,
            animated: false
        )
    }
}
