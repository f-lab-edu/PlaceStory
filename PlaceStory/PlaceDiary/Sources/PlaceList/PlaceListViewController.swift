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
    
    let placeRecordTableView: UITableView = {
        let uiTableView = UITableView()
        uiTableView.separatorStyle = .none
        uiTableView.backgroundColor = .systemBackground
        
        return uiTableView
    }()
    
    private let sampleDatas: [PlaceRecord] = [
        PlaceRecord(id: "111", userId: "111", placeName: "서울역", recordTitle: "부산 여행", recordDescription: "부산 여행을 위해 서울역에 갔다. 서울역에서 점심을 먹은 후 출발했다.", placeCategory: "역", registerDate: Date(), updateDate: Date(), recordImages: nil),
        PlaceRecord(id: "112", userId: "111", placeName: "서울역", recordTitle: "픽업", recordDescription: "친구가 지방에서 KTX를 타고 올라왔다. 마중하기 위해 픽업라러 갔다.", placeCategory: "테마파크", registerDate: Date(timeIntervalSinceNow: -86400), updateDate: Date(), recordImages: nil),
        PlaceRecord(id: "113", userId: "111", placeName: "서울역", recordTitle: "점심 시간", recordDescription: "서울역 안에 있는 김밥 천국집에 갔다. 김밥 한 줄이 너무 비싸지만 빠르게 먹기 위해 김밥 천국에서 김밥 2줄을 사서 왔다. 여기 김밥은 다른 곳보다 맛있는 것 같다.", placeCategory: "음식점", registerDate: Date(timeIntervalSinceNow: -86400 * 2), updateDate: Date(), recordImages: nil)
    ]

    weak var listener: PlaceListPresentableListener?
    
    private var placeRecords: [PlaceRecord] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        configurePlaceRecordTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "장소 모음"
        
        view.addSubview(headerView)
        view.addSubview(placeRecordTableView)
        
        headerView.addSubview(editButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(addButton)
        
        configureTabbarItem()
        configureHeaderViewAutoLayout()
        configureEditButtonAutoLayout()
        configureTitleLabelAutoLayout()
        configureAddButtonAutoLayout()
        configurePlaceRecordTableViewAutoLayout()
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
    
    private func configurePlaceRecordTableViewAutoLayout() {
        placeRecordTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configurePlaceRecordTableView() {
        placeRecordTableView.dataSource = self
        placeRecordTableView.delegate = self
        placeRecordTableView.register(PlaceRecordTableViewCell.self, forCellReuseIdentifier: PlaceRecordTableViewCell.identifier)
    }
    
    private func configureTalbeViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceRecordTableViewCell.identifier, for: indexPath) as? PlaceRecordTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configureUI(placeRecords[indexPath.row])
        
        return cell
    }
    
    // MARK: - PlaceListPresentable
    
    func configureTitle(from placeName: String) {
        titleLabel.text = placeName
    }
    
    func updatePlaceRecord(_ placeRecords: [PlaceRecord]) {
        self.placeRecords = sampleDatas
        
        placeRecordTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PlaceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureTalbeViewCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - UITableViewDelegate

extension PlaceListViewController: UITableViewDelegate {
    
}
