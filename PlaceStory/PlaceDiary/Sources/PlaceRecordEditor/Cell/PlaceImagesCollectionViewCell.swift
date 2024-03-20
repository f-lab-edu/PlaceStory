//
//  File.swift
//  
//
//  Created by 최제환 on 3/19/24.
//

import SnapKit
import UIKit

final class PlaceImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaceImagesCollectionViewCell"
    
    private let placeImage: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleToFill
        uiImageView.layer.cornerRadius = 10
        
        return uiImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    private func configureUI() {
        contentView.addSubview(placeImage)
        
        configurePlaceImage()
    }
    
    private func configurePlaceImage() {
        placeImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureCell(
        from viewModel: PlaceRecordEditorViewModel
    ) {
        let uiImage = UIImage(data: viewModel.placeImage)
        placeImage.image = uiImage
    }
}
