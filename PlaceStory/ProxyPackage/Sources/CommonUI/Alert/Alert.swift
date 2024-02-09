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
        _ handler: (() -> Void)?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "확인"
            , style: .cancel,
            handler: { _ in
                handler?()
            }
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
        _ okHandler: (() -> Void)?,
        _ cancelButtonTitle: String,
        _ cancelHandler: (() -> Void)?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: okButtonTitle,
            style: .default,
            handler: { _ in
                okHandler?()
            }
        )
        
        let cancelAction = UIAlertAction(
            title: cancelButtonTitle,
            style: .cancel,
            handler: { _ in
                cancelHandler?()
            }
        )
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        viewController.present(
            alertController,
            animated: false
        )
    }
}
