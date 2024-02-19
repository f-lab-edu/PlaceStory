//
//  PlaceListViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import Entities
import ModernRIBs
import SnapKit
import UIKit

protocol PlaceListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PlaceListViewController: UIViewController, PlaceListPresentable, PlaceListViewControllable {
    
    let headerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemBackground
        
        return uiView
    }()
    
    let editButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setTitle("편집", for: .normal)
        uiButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        uiButton.setTitleColor(uiButton.tintColor, for: .normal)
        
        return uiButton
    }()
    
    let titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 20, weight: .bold)
        uiLabel.textAlignment = .center
        
        return uiLabel
    }()
    
    let addButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setImage(
            UIImage(
                systemName: "square.and.pencil",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 24,
                    weight: .bold
                )
            )
            , for: .normal
        )
        
        return uiButton
    }()

    weak var listener: PlaceListPresentableListener?
    
    private var placeRecords: [PlaceRecord] = []
    
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
        
        view.addSubview(headerView)
        
        headerView.addSubview(editButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(addButton)
        
        configureTabbarItem()
        configureHeaderViewAutoLayout()
        configureEditButtonAutoLayout()
        configureTitleLabelAutoLayout()
        configureAddButtonAutoLayout()
    }
    
    private func configureTabbarItem() {
        let defaultImage = UIImage(systemName: "calendar.circle")
        let selectedImage = UIImage(systemName: "calendar.circle.fill")
        tabBarItem = UITabBarItem(title: "장소 모음", image: defaultImage, selectedImage: selectedImage)
    }
    
    private func configureHeaderViewAutoLayout() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(50)
        }
    }
    
    private func configureEditButtonAutoLayout() {
        editButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    private func configureTitleLabelAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(editButton.snp.trailing).offset(8)
            make.trailing.equalTo(addButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureAddButtonAutoLayout() {
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    // MARK: - PlaceListPresentable
    
    func configureTitle(from placeName: String) {
        titleLabel.text = placeName
    }
    
    func updatePlaceRecord(_ placeRecords: [PlaceRecord]) {
        self.placeRecords = placeRecords
    }
}
