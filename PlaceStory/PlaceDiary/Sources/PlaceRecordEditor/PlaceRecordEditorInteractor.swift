//
//  PlaceRecordEditorInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 2/27/24.
//

import ModernRIBs

public protocol PlaceRecordEditorRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PlaceRecordEditorPresentable: Presentable {
    var listener: PlaceRecordEditorPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol PlaceRecordEditorListener: AnyObject {
    func placeRecordEditorDidTapCancel()
    func placeRecordEditorDidTapDone()
}

final class PlaceRecordEditorInteractor: PresentableInteractor<PlaceRecordEditorPresentable>, PlaceRecordEditorInteractable, PlaceRecordEditorPresentableListener {

    weak var router: PlaceRecordEditorRouting?
    weak var listener: PlaceRecordEditorListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PlaceRecordEditorPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
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
}
