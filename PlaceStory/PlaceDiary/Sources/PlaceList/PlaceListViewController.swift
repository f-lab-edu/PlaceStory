//
//  PlaceListViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import ModernRIBs
import UIKit

protocol PlaceListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PlaceListViewController: UIViewController, PlaceListPresentable, PlaceListViewControllable {

    weak var listener: PlaceListPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "장소 모음"
        
        configureTabbarItem()
    }
    
    private func configureTabbarItem() {
        let defaultImage = UIImage(systemName: "calendar.circle")
        let selectedImage = UIImage(systemName: "calendar.circle.fill")
        tabBarItem = UITabBarItem(title: "장소 모음", image: defaultImage, selectedImage: selectedImage)
    }
}
