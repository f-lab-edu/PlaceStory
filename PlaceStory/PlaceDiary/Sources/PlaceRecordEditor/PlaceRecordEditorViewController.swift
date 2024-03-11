//
//  PlaceRecordEditorViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 2/27/24.
//

import ModernRIBs
import SnapKit
import UIKit
import Utils

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
    
    private let recordTitleView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemBackground
        
        return uiView
    }()
    
    private let recordTitleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "제목"
        uiLabel.font = .boldSystemFont(ofSize: 17)
        
        return uiLabel
    }()
    
    private let recordTitleTextField: UITextField = {
        let uiTextField = UITextField()
        uiTextField.placeholder = "제목을 입력하세요"
        uiTextField.borderStyle = .roundedRect
        uiTextField.addDoneToolbar()
        
        return uiTextField
    }()
    
    private let recordContentView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemBackground
        
        return uiView
    }()
    
    private let recordContentLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "내용"
        uiLabel.font = .boldSystemFont(ofSize: 17)
        
        return uiLabel
    }()
    
    private lazy var recordContentTextView: UITextView = {
        let uiTextView = UITextView()
        uiTextView.layer.borderWidth = 1.0
        uiTextView.layer.borderColor = UIColor.systemGray6.cgColor
        uiTextView.layer.cornerRadius = 10
        uiTextView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        uiTextView.font = .systemFont(ofSize: 17)
        uiTextView.text = textViewPlaceHolder
        uiTextView.textColor = .systemGray3
        uiTextView.addDoneButtonOnToolbar()
        
        return uiTextView
    }()
    
    let textViewPlaceHolder = "내용을 입력하세요"
    
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
        view.addSubview(recordTitleView)
        view.addSubview(recordContentView)
        
        headerView.addSubview(cancelButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(doneButton)
        
        recordTitleView.addSubview(recordTitleLabel)
        recordTitleView.addSubview(recordTitleTextField)
        
        recordContentView.addSubview(recordContentLabel)
        recordContentView.addSubview(recordContentTextView)
        
        configureHeaderViewAutoLayout()
        configureCancelButtonAutoLayout()
        configureTitleLabelAutoLayout()
        configureDoneButtonAutoLayout()
        configureRecordTitleView()
        configureRecordTitleLabel()
        configureRecordTitleTextField()
        configureRecordContentView()
        configureRecordContentLabel()
        configureRecordContentTextView()
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
    
    private func configureRecordTitleView() {
        recordTitleView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
    }
    
    private func configureRecordTitleLabel() {
        recordTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recordTitleView.snp.centerY)
            make.leading.equalToSuperview()
        }
    }
    
    private func configureRecordTitleTextField() {
        recordTitleTextField.snp.makeConstraints { make in
            make.centerY.equalTo(recordTitleView.snp.centerY)
            make.leading.equalTo(recordTitleLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
    
    private func configureRecordContentView() {
        recordContentView.snp.makeConstraints { make in
            make.top.equalTo(recordTitleView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
    }
    
    private func configureRecordContentLabel() {
        recordContentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recordContentView.snp.centerY)
            make.leading.equalToSuperview()
        }
    }
    
    private func configureRecordContentTextView() {
        recordContentTextView.snp.makeConstraints { make in
            make.leading.equalTo(recordContentLabel.snp.trailing).offset(16)
            make.top.trailing.bottom.equalToSuperview()
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
