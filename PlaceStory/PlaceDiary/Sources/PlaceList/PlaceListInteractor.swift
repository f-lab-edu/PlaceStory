//
//  PlaceListInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import Combine
import ModernRIBs
import UseCase
import Utils

public protocol PlaceListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
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

final class PlaceListInteractor: PresentableInteractor<PlaceListPresentable>, PlaceListInteractable, PlaceListPresentableListener {
    
    private let dependency: PlaceListInteractorDependency

    weak var router: PlaceListRouting?
    weak var listener: PlaceListListener?
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: PlaceListPresentable,
        dependency: PlaceListInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        
        super.init(presenter: presenter)
        presenter.listener = self
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
}
