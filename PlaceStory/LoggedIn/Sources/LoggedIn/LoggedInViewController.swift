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
    }
    
    func setViewControllers() {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .white
        vc1.title = "홈"
        vc1.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .white
        vc2.title = "장소 기록"
        vc2.tabBarItem = UITabBarItem(title: "장소 기록", image: UIImage(systemName: "mappin.and.ellipse.circle"), selectedImage: UIImage(systemName: "mappin.and.ellipse.circle.fill"))
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        self.setViewControllers([nav1, nav2], animated: true)
    }
}
