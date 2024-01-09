//
//  PlaceSearcherInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import Combine
import MapKit
import ModernRIBs
import UseCase
import Utils

public protocol PlaceSearcherRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PlaceSearcherPresentable: Presentable {
    var listener: PlaceSearcherPresentableListener? { get set }
    
    func updateSearchCompletion(_ results: [MKLocalSearchCompletion])
}

public protocol PlaceSearcherListener: AnyObject {
    func placeSearcherDidTapClose()
    func selectedLocation(_ coordinate: CLLocation, _ locationTitle: String)
}

final class PlaceSearcherInteractor: PresentableInteractor<PlaceSearcherPresentable>, PlaceSearcherInteractable, PlaceSearcherPresentableListener {

    weak var router: PlaceSearcherRouting?
    weak var listener: PlaceSearcherListener?

    private let mapServiceUseCase: MapServiceUseCase
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: PlaceSearcherPresentable,
        mapServiceUseCase: MapServiceUseCase
    ) {
        self.mapServiceUseCase = mapServiceUseCase
        self.cancellables = .init()
        
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
    
    // MARK: - PlaceSearcherPresentableListener
    
    func didTapCloseButton() {
        listener?.placeSearcherDidTapClose()
    }
    
    func didChangeSearchText(_ text: String) {
        mapServiceUseCase.updateSearchText(text)
            .sink(receiveValue: { [weak self] searchCompletion in
                guard let self else { return }
                
                self.presenter.updateSearchCompletion(searchCompletion)
            })
            .store(in: &cancellables)
    }
    
    func didSelect(at index: Int) {
        mapServiceUseCase.selectedLocation(at: index)
            .sink { [weak self] coordinate, locationTitle in
                guard let self else { return }
                
                self.listener?.selectedLocation(coordinate, locationTitle)
            }
            .store(in: &cancellables)
    }
}
