//
//  MyLocationViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import MapKit
import ModernRIBs
import SnapKit
import UIKit

protocol MyLocationPresentableListener: AnyObject {
    func checkPermissionLocation()
}

final class MyLocationViewController: UIViewController, MyLocationPresentable, MyLocationViewControllable {

    weak var listener: MyLocationPresentableListener?
    
    lazy var myPlaceMapView: MapView = {
        let mapView = MapView()
        
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        listener?.checkPermissionLocation()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = "장소 검색"
        
        view.addSubview(myPlaceMapView)
        
        configureTabbarItem()
        configureMyPlaceMapViewConstraint()
    }
    
    private func configureTabbarItem() {
        let defaultImage = UIImage(systemName: "map")
        let selectedImage = UIImage(systemName: "map.fill")
        tabBarItem = UITabBarItem(title: "장소 검색", image: defaultImage, selectedImage: selectedImage)
    }
    
    private func configureMyPlaceMapViewConstraint() {
        myPlaceMapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
