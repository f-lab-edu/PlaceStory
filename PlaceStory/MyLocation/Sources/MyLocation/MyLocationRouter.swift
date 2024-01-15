//
//  MyLocationRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import CommonUI
import ModernRIBs
import PlaceSearcher

protocol MyLocationInteractable: Interactable, PlaceSearcherListener {
    var router: MyLocationRouting? { get set }
    var listener: MyLocationListener? { get set }
    var modalAdaptivePresentationControllerDelegateProxy: ModalAdaptivePresentationControllerDelegateProxy { get }
}

protocol MyLocationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyLocationRouter: ViewableRouter<MyLocationInteractable, MyLocationViewControllable>, MyLocationRouting {

    private let placeSearcherBuilder: PlaceSearcherBuildable
    var placeSearcherRouter: PlaceSearcherRouting?
    
    init(
        interactor: MyLocationInteractable, 
        viewController: MyLocationViewControllable,
        placeSearcherBuilder: PlaceSearcherBuildable
    ) {
        self.placeSearcherBuilder = placeSearcherBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPlaceSearcher() {
        guard placeSearcherRouter == nil else { return }
        
        let router = placeSearcherBuilder.build(withListener: interactor)
        
        placeSearcherRouter = router
        attachChild(router)
        
        let vc = router.viewControllable.uiviewController
        vc.presentationController?.delegate = interactor.modalAdaptivePresentationControllerDelegateProxy
        
        viewControllable.uiviewController.present(vc, animated: true)
    }
    
    func detachPlaceSearcher() {
        guard let router = placeSearcherRouter else { return }
        
        router.viewControllable.uiviewController.dismiss(animated: true)
        detachChild(router)
        placeSearcherRouter = nil
    }
}
