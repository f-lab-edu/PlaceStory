//
//  PlaceListInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import Combine
import CommonUI
import Entities
import ModernRIBs
import UseCase
import Utils
import Foundation

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
                
                let placeListViewModel: [PlaceListViewModel] = [
                    PlaceListViewModel(
                        PlaceRecord(
                            id: "111",
                            userId: "111",
                            placeName: "서울역",
                            recordTitle: "부산 여행",
                            recordDescription: "부산 여행을 위해 서울역에 갔다. 서울역에서 점심을 먹은 후 출발했다.",
                            placeCategory: "역",
                            registerDate: Date(),
                            updateDate: Date(),
                            recordImages: nil
                        )
                    ),
                    PlaceListViewModel(
                        PlaceRecord(
                            id: "112",
                            userId: "111",
                            placeName: "서울역",
                            recordTitle: "픽업",
                            recordDescription: "친구가 지방에서 KTX를 타고 올라왔다. 마중하기 위해 픽업라러 갔다.",
                            placeCategory: "테마파크",
                            registerDate: Date(timeIntervalSinceNow: -86400),
                            updateDate: Date(),
                            recordImages: nil
                        )
                    ),
                    PlaceListViewModel(
                        PlaceRecord(
                            id: "113",
                            userId: "111",
                            placeName: "서울역",
                            recordTitle: "점심 시간",
                            recordDescription: "서울역 안에 있는 김밥 천국집에 갔다. 김밥 한 줄이 너무 비싸지만 빠르게 먹기 위해 김밥 천국에서 김밥 2줄을 사서 왔다. 여기 김밥은 다른 곳보다 맛있는 것 같다.",
                            placeCategory: "음식점",
                            registerDate: Date(timeIntervalSinceNow: -86400 * 2),
                            updateDate: Date(),
                            recordImages: nil
                        )
                    )
                ]
                
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
    
    func removePlaceListViewModel(from placeListViewModels: [PlaceListViewModel], at index: Int, completionHandler: @escaping ([PlaceListViewModel]) -> Void) {
        var placeListViewModels = placeListViewModels
        placeListViewModels.remove(at: index)
        completionHandler(placeListViewModels)
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
