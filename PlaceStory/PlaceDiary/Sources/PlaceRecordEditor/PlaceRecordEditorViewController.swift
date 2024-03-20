//
//  PlaceRecordEditorViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 2/27/24.
//

import CommonUI
import Entities
import ModernRIBs
import SnapKit
import UIKit
import Utils
import PhotosUI

protocol PlaceRecordEditorPresentableListener: AnyObject {
    func didTapCancelButton()
    func didTapDoneButton()
    func didTapAddImageButton()
}

final class PlaceRecordEditorViewController: UIViewController, PlaceRecordEditorPresentable, PlaceRecordEditorViewControllable {
    
    enum Section: Int {
        case image
    }

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
    
    private let placeImageView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemBackground
        
        return uiView
    }()
    
    private let placeImageTitleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "사진"
        uiLabel.font = .boldSystemFont(ofSize: 17)
        
        return uiLabel
    }()
    
    private lazy var addImageButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setImage(
            UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 24,
                    weight: .bold
                )
            )
            , for: .normal
        )
        uiButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
        
        return uiButton
    }()
    
    private lazy var placeImagesCollectionView: UICollectionView = {
        let uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        uiCollectionView.backgroundColor = .systemBackground
        uiCollectionView.layer.cornerRadius = 10
        uiCollectionView.layer.borderWidth = 1.0
        uiCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        
        return uiCollectionView
    }()
    
    let textViewPlaceHolder = "내용을 입력하세요"
    
    weak var listener: PlaceRecordEditorPresentableListener?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, RecordImage>!
    private var placeRecordEditorViewModels: [PlaceRecordEditorViewModel] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        configurePlaceImagesCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(recordTitleView)
        view.addSubview(recordContentView)
        view.addSubview(placeImageView)
        
        headerView.addSubview(cancelButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(doneButton)
        
        recordTitleView.addSubview(recordTitleLabel)
        recordTitleView.addSubview(recordTitleTextField)
        
        recordContentView.addSubview(recordContentLabel)
        recordContentView.addSubview(recordContentTextView)
        
        placeImageView.addSubview(placeImageTitleLabel)
        placeImageView.addSubview(addImageButton)
        placeImageView.addSubview(placeImagesCollectionView)
        
        configureHeaderViewAutoLayout()
        configureCancelButtonAutoLayout()
        configureTitleLabelAutoLayout()
        configureDoneButtonAutoLayout()
        configureRecordTitleViewAutoLayout()
        configureRecordTitleLabelAutoLayout()
        configureRecordTitleTextFieldAutoLayout()
        configureRecordContentViewAutoLayout()
        configureRecordContentLabelAutoLayout()
        configureRecordContentTextViewAutoLayout()
        configurePlaceImageViewAutoLayout()
        configurePlaceImageTitleLabelAutoLayout()
        configureAddImageButtonAutoLayout()
        configurePlaceImageCollectionViewAutoLayout()
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
    
    private func configureRecordTitleViewAutoLayout() {
        recordTitleView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
    }
    
    private func configureRecordTitleLabelAutoLayout() {
        recordTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recordTitleView.snp.centerY)
            make.leading.equalToSuperview()
        }
    }
    
    private func configureRecordTitleTextFieldAutoLayout() {
        recordTitleTextField.snp.makeConstraints { make in
            make.centerY.equalTo(recordTitleView.snp.centerY)
            make.leading.equalTo(recordTitleLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
    
    private func configureRecordContentViewAutoLayout() {
        recordContentView.snp.makeConstraints { make in
            make.top.equalTo(recordTitleView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
    }
    
    private func configureRecordContentLabelAutoLayout() {
        recordContentLabel.snp.makeConstraints { make in
            make.top.equalTo(recordContentView.snp.centerY)
            make.leading.equalToSuperview()
        }
    }
    
    private func configureRecordContentTextViewAutoLayout() {
        recordContentTextView.snp.makeConstraints { make in
            make.leading.equalTo(recordContentLabel.snp.trailing).offset(16)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configurePlaceImageViewAutoLayout() {
        placeImageView.snp.makeConstraints { make in
            make.top.equalTo(recordContentView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
    }
    
    private func configurePlaceImageTitleLabelAutoLayout() {
        placeImageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.top).inset(16)
            make.leading.equalToSuperview()
        }
    }
    
    private func configureAddImageButtonAutoLayout() {
        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(placeImageView.snp.top).inset(16)
            make.trailing.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
    
    private func configurePlaceImageCollectionViewAutoLayout() {
        placeImagesCollectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
    }
    
    private func configurePlaceImagesCollectionView() {
        configureDataSource()
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PlaceImagesCollectionViewCell, RecordImage> { [weak self] cell, indexPath, viewModel in
            guard let self else { return }
            
            cell.configureCell(from: self.placeRecordEditorViewModels[indexPath.row])
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, RecordImage>(collectionView: placeImagesCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            switch section {
            case .image:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        })
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    private func applyPlaceImagesSnapshot(from recordImages: [RecordImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecordImage>()
        snapshot.appendSections([.image])
        snapshot.appendItems(recordImages, toSection: .image)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.dataSource.apply(snapshot)
        }
        
        self.placeImagesCollectionView.collectionViewLayout = self.configureLayout()
    }
    
    // MARK: - Selector Method
    
    @objc
    private func didTapCancelButton() {
        listener?.didTapCancelButton()
    }
    
    @objc
    private func didTapDoneButton() {
        listener?.didTapDoneButton()
    }
    
    @objc
    private func didTapAddImageButton() {
        listener?.didTapAddImageButton()
    }
    
    // MARK: - PlaceRecordEditorPresentable
    
    func presentPhotoPicker(_ pickerVC: PHPickerViewController) {
        self.present(pickerVC, animated: true)
    }
    
    func removeViewModel() {
        placeRecordEditorViewModels.removeAll()
    }
    
    func update(from viewModels: [PlaceRecordEditorViewModel], with recordImages: [RecordImage]) {
        placeRecordEditorViewModels = viewModels
        applyPlaceImagesSnapshot(from: recordImages)
    }
}
