//
//  SearchTableViewCell.swift
//  
//
//  Created by 최제환 on 1/8/24.
//

import SnapKit
import Utils
import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    lazy var placeLabel: UILabel = {
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
        addSubview(placeLabel)
        
        configurePlaceLabelAutoLayout()
    }
    
    private func configurePlaceLabelAutoLayout() {
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.top.bottom.equalToSuperview()
        }
    }

    func configureUI(_ place: String) {
        Log.info("place = \(place)", "[\(#file)-\(#function) - \(#line)]")
        placeLabel.text = place
    }
}
