//
//  File.swift
//
//
//  Created by 최제환 on 1/23/24.
//

import UIKit

enum PlaceMapViewButtonType {
    case placeSearch
    case myLocation
}



//protocol PlaceMapViewButtonConfigurable where Self: UIButton {
//    var delegate: PlaceMapButtonDelegate? { get set }
//    
//    func didTap()
//}
//
//final class PlaceSearchButton: UIButton, PlaceMapViewButtonConfigurable {
//    weak var delegate: PlaceMapButtonDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        configureSelf()
//        
//        addTarget(self, action: #selector(didTap), for: .touchUpInside)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configureSelf() {
//        self.setImage(
//            UIImage(
//                systemName: "magnifyingglass",
//                withConfiguration: UIImage.SymbolConfiguration(
//                    pointSize: 14,
//                    weight: .medium
//                )
//            ),
//            for: .normal
//        )
//        self.backgroundColor = .white
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.cornerRadius = 10.0
//        self.tintColor = .black
//    }
//    
//    @objc func didTap() {
//        delegate?.didTapPlaceSearch?()
//    }
//}
//
//final class MyLocationButton: UIButton, PlaceMapViewButtonConfigurable {
//    weak var delegate: PlaceMapButtonDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        configureSelf()
//        
//        addTarget(self, action: #selector(didTap), for: .touchUpInside)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configureSelf() {
//        self.setImage(
//            UIImage(
//                systemName: "location.fill",
//                withConfiguration: UIImage.SymbolConfiguration(
//                    pointSize: 14,
//                    weight: .medium
//                )
//            ),
//            for: .normal
//        )
//        self.backgroundColor = .white
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.cornerRadius = 10.0
//        self.tintColor = .black
//    }
//    
//    @objc func didTap() {
//        delegate?.didTapMyLocation?()
//    }
//}
//
//protocol PlaceMapViewButtonFactory {
//    func makePlaceMapViewButton(of type: PlaceMapViewButtonType) -> PlaceMapViewButtonConfigurable
//}
//
//public final class PlaceMapViewButtonFactoryImp: PlaceMapViewButtonFactory {
//    func makePlaceMapViewButton(of type: PlaceMapViewButtonType) -> PlaceMapViewButtonConfigurable {
//        switch type {
//        case .placeSearch:
//            return PlaceSearchButton()
//            
//        case .myLocation:
//            return MyLocationButton()
//        }
//    }
//}
