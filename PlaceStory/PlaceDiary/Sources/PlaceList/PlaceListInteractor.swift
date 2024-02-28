//
//  PlaceListInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import Combine
import CommonUI
import ModernRIBs
import UseCase
import Utils

public protocol PlaceListRouting: ViewableRouting {
    func attachPlaceRecordEditor()
    func detachPlaceRecordEditor()
}

protocol PlaceListPresentable: Presentable {
    var listener: PlaceListPresentableListener? { get set }
    
    func update(from viewModels: [PlaceListViewModel])
}

public protocol PlaceListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol PlaceListInteractorDependency {
    var placeListUsecase: PlaceListUsecase { get }
    var placeName: String { get }
}

final class PlaceListInteractor: PresentableInteractor<PlaceListPresentable>, PlaceListInteractable, PlaceListPresentableListener, ModalAdaptivePresentationControllerDelegate {
    
    private let dependency: PlaceListInteractorDependency

    let modalAdaptivePresentationControllerDelegateProxy: ModalAdaptivePresentationControllerDelegateProxy
    
    weak var router: PlaceListRouting?
    weak var listener: PlaceListListener?
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: PlaceListPresentable,
        dependency: PlaceListInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.modalAdaptivePresentationControllerDelegateProxy = ModalAdaptivePresentationControllerDelegateProxy()
        
        super.init(presenter: presenter)
        presenter.listener = self
        
        modalAdaptivePresentationControllerDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.placeListUsecase.searchPlaceRecordFrom(placeName: dependency.placeName)
            .sink { error in
                Log.error("error is \(error)", "[\(#file)-\(#function) - \(#line)]")
            } receiveValue: { [weak self] placeRecord in
                guard let self else { return }
                
                Log.info("placeRecord = \(placeRecord)", "[\(#file)-\(#function) - \(#line)]")
                
                let placeListViewModel: [PlaceListViewModel] = placeRecord.map(PlaceListViewModel.init)
                
                self.presenter.update(from: placeListViewModel)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - PlaceListPresentableListener
    
    func didTapAddButton() {
        router?.attachPlaceRecordEditor()
    }
    
    // MARK: - ModalAdaptivePresentationControllerDelegate
    
    func presentationControllerDidDismiss() {
        router?.detachPlaceRecordEditor()
    }
    
    // MARK: - PlaceListInteractable
    
    func placeRecordEditorDidTapCancel() {
        router?.detachPlaceRecordEditor()
    }
    
    func placeRecordEditorDidTapDone() {
        router?.detachPlaceRecordEditor()
    }
}
