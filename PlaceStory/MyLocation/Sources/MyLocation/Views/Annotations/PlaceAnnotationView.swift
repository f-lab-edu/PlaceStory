//
//  File.swift
//
//
//  Created by 최제환 on 1/17/24.
//

import MapKit
import SnapKit
import UIKit

final class PlaceAnnotationView: MKAnnotationView {
    
    lazy var annotationImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFit
        
        return uiImageView
    }()
    
    static let identifier = "PlaceAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        annotationImageView.image = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? PlaceAnnotation else { return }
        
        guard let imageName = annotation.imageName,
              let image = UIImage(named: imageName) else { return }
        
        annotationImageView.image = image
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bounds.size = CGSize(width: 32, height: 32)
        
        centerOffset = CGPoint(x: 0, y: -16)
    }
    
    private func configUI() {
        addSubview(annotationImageView)
        
        configureAnnotationImageViewAutoLayout()
    }
    
    private func configureAnnotationImageViewAutoLayout() {
        annotationImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
    }
}
