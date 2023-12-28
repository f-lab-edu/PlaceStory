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
            title: "확인"
            , style: .cancel,
            handler: handler
        )
        
        alertController.addAction(action)
        
        viewController.present(
            alertController,
            animated: false
        )
    }
    
    public static func showAlertWithTwoAction(
        _ viewController: UIViewController,
        _ title: String,
        _ message: String,
        _ okButtonTitle: String,
        _ okHandler: ((UIAlertAction) -> ())?,
        _ cancelButtonTitle: String,
        _ cancelHandler: ((UIAlertAction) -> ())?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: okButtonTitle,
            style: .default,
            handler: okHandler
        )
        
        let cancelAction = UIAlertAction(
            title: cancelButtonTitle,
            style: .cancel,
            handler: cancelHandler
        )
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        viewController.present(
            alertController,
            animated: false
        )
    }
}
