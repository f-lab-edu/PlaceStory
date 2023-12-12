//
//  AppRootViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppRootViewController: UIViewController, AppRootPresentable, AppRootViewControllable {

    weak var listener: AppRootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Place Story"
        view.backgroundColor = .systemPink
    }
    
    func present(viewController: ModernRIBs.ViewControllable) {
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        present(viewController.uiviewController, animated: true, completion: nil)
    }
}
