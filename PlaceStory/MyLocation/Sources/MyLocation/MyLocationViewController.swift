//
//  MyLocationViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import ModernRIBs
import UIKit

protocol MyLocationPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyLocationViewController: UIViewController, MyLocationPresentable, MyLocationViewControllable {

    weak var listener: MyLocationPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = "장소 검색"
        
        configureTabbarItem()
    }
    
    private func configureTabbarItem() {
        let defaultImage = UIImage(systemName: "map")
        let selectedImage = UIImage(systemName: "map.fill")
        tabBarItem = UITabBarItem(title: "장소 검색", image: defaultImage, selectedImage: selectedImage)
    }
}
