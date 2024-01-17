//
//  SearchTableViewCell.swift
//  
//
//  Created by 최제환 on 1/8/24.
//

import SnapKit
import Utils
import UIKit

final class SearchTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    lazy var stackView: UIStackView = {
        let uiStackView = UIStackView(arrangedSubviews: [placeLabel, addressLabel])
        uiStackView.axis = .vertical
        uiStackView.distribution = .fillEqually
        
        return uiStackView
    }()
    
    let placeLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        uiLabel.textColor = .darkGray
        
        return uiLabel
    }()
    
    let addressLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        uiLabel.textColor = .lightGray
        
        return uiLabel
    }()
    
    // MARK: - Property
    
    static let identifier = "SearchTableViewCell"

    // MARK: - View Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func configureUI() {
        addSubview(stackView)
        
        configureStackViewAutoLayout()
    }
    
    private func configureStackViewAutoLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview().inset(8)
        }
    }

    func configureUI(
        _ place: String,
        _ address: String
    ) {
        placeLabel.text = place
        addressLabel.text = address
    }
}
