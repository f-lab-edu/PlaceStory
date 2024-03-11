//
//  PlaceListViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import ModernRIBs
import SnapKit
import UIKit

protocol PlaceListPresentableListener: AnyObject {
    func didTapAddButton()
    func removePlaceListViewModel(from placeListViewModels: [PlaceListViewModel], at index: Int, completionHandler: @escaping ([PlaceListViewModel]) -> Void)
}

final class PlaceListViewController: UIViewController, PlaceListPresentable, PlaceListViewControllable {
    
    private let headerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemBackground
        
        return uiView
    }()
    
    private lazy var editButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setTitle("편집", for: .normal)
        uiButton.setTitle("완료", for: .selected)
        uiButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        uiButton.setTitleColor(uiButton.tintColor, for: .normal)
        uiButton.setTitleColor(.red, for: .selected)
        uiButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        return uiButton
    }()
    
    private let titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 20, weight: .bold)
        uiLabel.textAlignment = .center
        
        return uiLabel
    }()
    
    private lazy var addButton: UIButton = {
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
        uiButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return uiButton
    }()
    
    private let placeRecordTableView: UITableView = {
        let uiTableView = UITableView()
        uiTableView.separatorStyle = .none
        uiTableView.backgroundColor = .systemBackground
        
        return uiTableView
    }()

    weak var listener: PlaceListPresentableListener?
    
    private var placeListViewModels: [PlaceListViewModel] = []
    
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
        
        configureHeaderViewAutoLayout()
        configureEditButtonAutoLayout()
        configureTitleLabelAutoLayout()
        configureAddButtonAutoLayout()
        configurePlaceRecordTableViewAutoLayout()
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
        cell.configureUI(placeListViewModels[indexPath.row])
        
        return cell
    }
    
    @objc
    private func didTapAddButton() {
        listener?.didTapAddButton()
    }
    
    @objc
    private func didTapEditButton() {
        let shouldBeEdited = !placeRecordTableView.isEditing
        placeRecordTableView.setEditing(shouldBeEdited, animated: true)
        editButton.isSelected = shouldBeEdited
    }
    
    // MARK: - PlaceListPresentable
    
    func update(from viewModels: [PlaceListViewModel]) {
        self.placeListViewModels = viewModels
        placeRecordTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PlaceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeListViewModels.count
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listener?.removePlaceListViewModel(from: placeListViewModels, at: indexPath.row, completionHandler: { [weak self] placeListViewModels in
                guard let self else { return }
                
                self.placeListViewModels = placeListViewModels
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }
    }
}
