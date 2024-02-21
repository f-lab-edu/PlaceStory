//
//  MyLocationRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import CommonUI
import ModernRIBs
import PlaceList
import PlaceSearcher
import Utils

protocol MyLocationInteractable: Interactable, PlaceSearcherListener, PlaceListListener {
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
    
    private let placeListBuilder: PlaceListBuildable
    var placeListRouter: PlaceListRouting?
    
    init(
        interactor: MyLocationInteractable, 
        viewController: MyLocationViewControllable,
        placeSearcherBuilder: PlaceSearcherBuildable,
        placeListBuilder: PlaceListBuildable
    ) {
        self.placeSearcherBuilder = placeSearcherBuilder
        self.placeListBuilder = placeListBuilder
        
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
    
    func attachPlaceList(_ placeNamePublisher: CurrentPublisher<String>) {
        guard placeListRouter == nil else { return }
        
        let router = placeListBuilder.build(withListener: interactor, placeNamePublisher: placeNamePublisher)
        
        placeListRouter = router
        attachChild(router)
        
        let vc = router.viewControllable.uiviewController
        vc.presentationController?.delegate = interactor.modalAdaptivePresentationControllerDelegateProxy
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        
        viewControllable.uiviewController.present(vc, animated: true)
    }
    
    func detachPresentationController() {
        if let router = placeSearcherRouter {
            router.viewControllable.uiviewController.dismiss(animated: true)
            detachChild(router)
            placeSearcherRouter = nil
        }
        
        if let router = placeListRouter {
            router.viewControllable.uiviewController.dismiss(animated: true)
            detachChild(router)
            placeListRouter = nil
        }
    }
}
