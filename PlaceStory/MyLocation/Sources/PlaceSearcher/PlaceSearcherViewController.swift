//
//  PlaceSearcherViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import CommonUI
import Entities
import MapKit
import ModernRIBs
import SnapKit
import Utils
import UIKit

protocol PlaceSearcherPresentableListener: AnyObject {
    func didTapCloseButton()
    func didChangeSearchText(_ text: String)
    func didSelect(at index: Int)
}

final class PlaceSearcherViewController: UIViewController, PlaceSearcherPresentable, PlaceSearcherViewControllable {
    
    // MARK: - UI Components
    
    lazy var titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "기록하고 싶은 장소 입력"
        uiLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        uiLabel.textColor = .white
        uiLabel.textAlignment = .center
        uiLabel.backgroundColor = UIColor(
            named: "logoLabel"
        )
        
        return uiLabel
    }()
    
    lazy var closeButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setImage(
            UIImage(
                systemName: "xmark",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 17,
                    weight: .bold
                )
            ),
            for: .normal
        )
        uiButton.tintColor = .white
        uiButton.addTarget(
            self,
            action: #selector(didTappedCloseButton),
            for: .touchUpInside
        )
        
        return uiButton
    }()
    
    lazy var searchBar: UISearchBar = {
        let uiSearchBar = UISearchBar()
        uiSearchBar.becomeFirstResponder()
        uiSearchBar.showsCancelButton = false
        uiSearchBar.searchBarStyle = .minimal
        uiSearchBar.searchTextField.placeholder = "검색"
        uiSearchBar.searchTextField.addDoneButtonOnToolbar()
        
        return uiSearchBar
    }()
    
    lazy var lineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .lightGray
        
        return uiView
    }()
    
    lazy var searchTableView: UITableView = {
        let uiTableView = UITableView()
        uiTableView.separatorStyle = .none
        uiTableView.backgroundColor = .systemBackground
        
        return uiTableView
    }()
    
    // MARK: - Property
    
    weak var listener: PlaceSearcherPresentableListener?
    var searchPlaceResults: [MKLocalSearchCompletion] = []
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchBar()
        configureSearchTableView()
    }
    
    // MARK: - Custom Method
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(searchBar)
        view.addSubview(lineView)
        view.addSubview(searchTableView)
        
        configureTitleLabelAutoLayout()
        configureCloseButtonAutoLayout()
        configureSearchBarAutoLayout()
        configureLineViewAutoLayout()
        configureSearchTableViewAutoLayout()
    }
    
    private func configureTitleLabelAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(50)
        }
    }
    
    private func configureCloseButtonAutoLayout() {
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
        }
    }
    
    private func configureSearchBarAutoLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(50)
        }
    }
    
    private func configureLineViewAutoLayout() {
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(1)
        }
    }
    
    private func configureSearchTableViewAutoLayout() {
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    private func configureSearchTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    private func configureTalbeViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configureUI(searchPlaceResults[indexPath.row].title)
        
        return cell
    }
    
    // MARK: - Button action Method
    
    @objc
    private func didTappedCloseButton() {
        listener?.didTapCloseButton()
    }
    
    // MARK: - PlaceSearcherPresentable
    
    func updateSearchCompletion(_ placeSearchResults: PlaceSearchResult) {
        searchPlaceResults = placeSearchResults.results
        searchTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PlaceSearcherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPlaceResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureTalbeViewCell(tableView, cellForRowAt: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension PlaceSearcherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.didSelect(at: indexPath.row)
    }
}

// MARK: - UISearchBarDelegate

extension PlaceSearcherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listener?.didChangeSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
