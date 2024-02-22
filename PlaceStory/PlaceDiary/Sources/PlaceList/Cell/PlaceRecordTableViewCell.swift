//
//  File.swift
//  
//
//  Created by 최제환 on 2/22/24.
//

import SnapKit
import Utils
import UIKit
import Entities

final class PlaceRecordTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    let cellContentView: UIView = {
        let uiView = UIView()
        
        return uiView
    }()
    
    let thumbnailImageView: UIImageView = {
        let uiImageView = UIImageView()
        
        return uiImageView
    }()
    
    let placeRecordBackgroundView: UIView = {
        let uiView = UIView()
        
        return uiView
    }()
    
    let placeRecordTitleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        return uiLabel
    }()
    
    lazy var stackView: UIStackView = {
        let uiStackView = UIStackView(arrangedSubviews: [placeRecordContentLabel, placeRecordDateLabel])
        uiStackView.axis = .horizontal
        uiStackView.distribution = .fillEqually
        
        return uiStackView
    }()
    
    let placeRecordContentLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 15, weight: .medium)
        uiLabel.textColor = .darkGray
        
        return uiLabel
    }()
    
    let placeRecordDateLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 15, weight: .medium)
        uiLabel.textColor = .darkGray
        uiLabel.textAlignment = .right
        
        return uiLabel
    }()
    
    // MARK: - Property
    
    static let identifier = "PlaceRecordTableViewCell"

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
        contentView.addSubview(cellContentView)
        
        cellContentView.addSubview(thumbnailImageView)
        cellContentView.addSubview(placeRecordBackgroundView)
        
        placeRecordBackgroundView.addSubview(placeRecordTitleLabel)
        placeRecordBackgroundView.addSubview(stackView)
        
        configureCellContentView()
        configureThumbnailImageViewAutoLayout()
        configurePlaceRecordBackgroundViewAutoLayout()
        configurePlaceRecordTitleLabelAutoLayout()
        configureStackViewAutoLayout()
    }
    private func configureCellContentView() {
        cellContentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configureThumbnailImageViewAutoLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.width.equalTo(50)
        }
    }
    
    private func configurePlaceRecordBackgroundViewAutoLayout() {
        placeRecordBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
    
    private func configurePlaceRecordTitleLabelAutoLayout() {
        placeRecordTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(stackView.snp.height)
        }
    }
    
    private func configureStackViewAutoLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(placeRecordTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureUI(
        _ placeRecord: PlaceRecord
    ) {
        if let recordImages = placeRecord.recordImages {
            let thumbnailImageData = recordImages[0]
            let uiImage = UIImage(data: thumbnailImageData)
            thumbnailImageView.image = uiImage
        }
        
        placeRecordTitleLabel.text = placeRecord.recordTitle
        
        placeRecordContentLabel.text = placeRecord.recordDescription
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let compareDateResult = placeRecord.registerDate.compare(placeRecord.updateDate)
        var dateDescription = ""
        
        switch compareDateResult {
        case .orderedAscending:
            dateDescription = "\(dateFormatter.string(from: placeRecord.updateDate)) (수정)"
            
        case .orderedDescending:
            break
            
        case .orderedSame:
            dateDescription = dateFormatter.string(from: placeRecord.registerDate)
        }
        
        placeRecordDateLabel.text = dateDescription
    }
}
