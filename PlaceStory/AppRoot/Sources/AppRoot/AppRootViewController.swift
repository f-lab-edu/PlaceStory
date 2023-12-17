//
//  AppRootViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
    func attachLoggedIn()
}

final class AppRootViewController: UIViewController, AppRootPresentable, AppRootViewControllable {

    // MARK: - Property
    
    weak var listener: AppRootPresentableListener?
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - AppRootViewControllable
    
    func present(viewController: ModernRIBs.ViewControllable) {
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        present(viewController.uiviewController, animated: true, completion: nil)
    }
    
    func dismiss(viewController: ViewControllable) {
        viewController.uiviewController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            self.listener?.attachLoggedIn()
        }
    }
    
    func presentLoggedIn() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.listener?.attachLoggedIn()
        }
    }
}
