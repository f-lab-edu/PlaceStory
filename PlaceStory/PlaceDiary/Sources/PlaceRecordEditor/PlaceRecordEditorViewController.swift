//
//  PlaceRecordEditorViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 2/27/24.
//

import ModernRIBs
import SnapKit
import UIKit

protocol PlaceRecordEditorPresentableListener: AnyObject {
    func didTapCancelButton()
    func didTapDoneButton()
}

final class PlaceRecordEditorViewController: UIViewController, PlaceRecordEditorPresentable, PlaceRecordEditorViewControllable {

    private let headerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemBackground
        
        return uiView
    }()
    
    private lazy var cancelButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setTitle("취소", for: .normal)
        uiButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        uiButton.setTitleColor(uiButton.tintColor, for: .normal)
        uiButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        return uiButton
    }()
    
    private let titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 20, weight: .bold)
        uiLabel.textAlignment = .center
        uiLabel.text = "장소 기록"
        
        return uiLabel
    }()
    
    private lazy var doneButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setTitle("완료", for: .normal)
        uiButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        uiButton.setTitleColor(uiButton.tintColor, for: .normal)
        uiButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        return uiButton
    }()
    weak var listener: PlaceRecordEditorPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        
        headerView.addSubview(cancelButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(doneButton)
        
        configureHeaderViewAutoLayout()
        configureCancelButtonAutoLayout()
        configureTitleLabelAutoLayout()
        configureDoneButtonAutoLayout()
    }
    
    private func configureHeaderViewAutoLayout() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(50)
        }
    }
    
    private func configureCancelButtonAutoLayout() {
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    private func configureTitleLabelAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(cancelButton.snp.trailing).offset(8)
            make.trailing.equalTo(doneButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureDoneButtonAutoLayout() {
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    @objc
    private func didTapCancelButton() {
        listener?.didTapCancelButton()
    }
    
    @objc
    private func didTapDoneButton() {
        listener?.didTapDoneButton()
    }
}
