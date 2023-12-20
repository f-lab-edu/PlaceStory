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
}
