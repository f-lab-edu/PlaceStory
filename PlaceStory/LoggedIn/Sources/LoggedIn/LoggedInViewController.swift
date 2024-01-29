//
//  LoggedInViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import ModernRIBs
import SnapKit
import UIKit

protocol LoggedInPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class LoggedInViewController: UITabBarController, LoggedInPresentable, LoggedInViewControllable {

    weak var listener: LoggedInPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabbar()
    }
    
    private func configureTabbar() {
        tabBar.backgroundColor = UIColor(named: "tabbarBackground")
        tabBar.tintColor = UIColor(named: "tabbarSelectedIcon")
        tabBar.unselectedItemTintColor = UIColor(named: "tabbarUnselectedIcon")
        tabBar.itemWidth = (tabBar.bounds.width - 40) / 3
    }
    
    private func wrapViewControllerInNavigation(_ viewController: UIViewController) -> UIViewController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.backgroundColor = .white
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
    
    // MARK: - LoggedInViewControllable
    func setViewControllers(_ viewControllables: [ViewControllable]) {
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .white
        vc3.title = "설정"
        vc3.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        var viewControllers: [UIViewController] = []
        viewControllables.forEach {
            viewControllers.append(wrapViewControllerInNavigation($0.uiviewController))
        }
        
        let nav3 = wrapViewControllerInNavigation(vc3)
        viewControllers.append(nav3)
        
        self.setViewControllers(viewControllers, animated: true)
    }
}
