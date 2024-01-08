//
//  PlaceSearcherInteractor.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import MapKit
import ModernRIBs
import Utils

public protocol PlaceSearcherRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PlaceSearcherPresentable: Presentable {
    var listener: PlaceSearcherPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol PlaceSearcherListener: AnyObject {
    func placeSearcherDidTapClose()
}

final class PlaceSearcherInteractor: PresentableInteractor<PlaceSearcherPresentable>, PlaceSearcherInteractable, PlaceSearcherPresentableListener {

    weak var router: PlaceSearcherRouting?
    weak var listener: PlaceSearcherListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PlaceSearcherPresentable) {
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
    
    func didTappedCloseButton() {
        listener?.placeSearcherDidTapClose()
    }
    
    func didSelected(for result: MKLocalSearchCompletion) {
        let searchReqeust = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchReqeust)
        search.start { response, error in
            guard error == nil else {
                Log.error("[MKLocalSearch] error is \(error.debugDescription)", "[\(#file)-\(#function) - \(#line)]")
                return
            }
            
            guard let placeMark = response?.mapItems[0].placemark else { return }
            
            Log.info("placeMark is \(placeMark)", "[\(#file)-\(#function) - \(#line)]")
        }
    }
}
