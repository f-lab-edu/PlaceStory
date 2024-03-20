//
//  PlaceRecordEditorInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 2/27/24.
//

import CommonUI
import Entities
import Foundation
import ModernRIBs
import PhotosUI

public protocol PlaceRecordEditorRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PlaceRecordEditorPresentable: Presentable {
    var listener: PlaceRecordEditorPresentableListener? { get set }
    
    func presentPhotoPicker(_ pickerVC: PHPickerViewController)
    func removeViewModel()
    func update(from viewModels: [PlaceRecordEditorViewModel], with recordImages: [RecordImage])
}

public protocol PlaceRecordEditorListener: AnyObject {
    func placeRecordEditorDidTapCancel()
    func placeRecordEditorDidTapDone()
}

final class PlaceRecordEditorInteractor: PresentableInteractor<PlaceRecordEditorPresentable>, PlaceRecordEditorInteractable, PlaceRecordEditorPresentableListener, PhotoPickerViewControllerDelegate {

    private let photoPicker: PhotoPicker
    private var recordImages: [RecordImage]
    
    weak var router: PlaceRecordEditorRouting?
    weak var listener: PlaceRecordEditorListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PlaceRecordEditorPresentable) {
        photoPicker = PhotoPicker(limit: 5, filter: .images)
        recordImages = []
        
        super.init(presenter: presenter)
        presenter.listener = self
        photoPicker.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - PlaceRecordEditorPresentableListener
    
    func didTapCancelButton() {
        listener?.placeRecordEditorDidTapCancel()
    }
    
    func didTapDoneButton() {
        listener?.placeRecordEditorDidTapDone()
    }
    
    func didTapAddImageButton() {
        presenter.presentPhotoPicker(photoPicker.getPickerViewController())
    }
    
    // MARK: - PhotoPickerViewControllerDelegate
    
    func nonSelectionImage() {
        presenter.removeViewModel()
    }
    
    func didFinishPicking(_ imageDatas: [Data]) {
        recordImages = imageDatas.map { RecordImage(placeImage: $0) }
        let viewModels = recordImages.map(PlaceRecordEditorViewModel.init)
        
        presenter.update(from: viewModels, with: recordImages)
    }
}
