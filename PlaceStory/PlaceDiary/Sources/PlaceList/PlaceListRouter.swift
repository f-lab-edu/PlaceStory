//
//  PlaceListRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import CommonUI
import ModernRIBs
import PlaceRecordEditor

protocol PlaceListInteractable: Interactable, PlaceRecordEditorListener {
    var router: PlaceListRouting? { get set }
    var listener: PlaceListListener? { get set }
    var modalAdaptivePresentationControllerDelegateProxy: ModalAdaptivePresentationControllerDelegateProxy { get }
}

protocol PlaceListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PlaceListRouter: ViewableRouter<PlaceListInteractable, PlaceListViewControllable>, PlaceListRouting {

    private let placeRecordEditorBuilder: PlaceRecordEditorBuildable
    var placeRecordEditorRouter: PlaceRecordEditorRouting?
    
    init(
        interactor: PlaceListInteractable,
        viewController: PlaceListViewControllable,
        placeRecordEditorBuilder: PlaceRecordEditorBuildable
    ) {
        self.placeRecordEditorBuilder = placeRecordEditorBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPlaceRecordEditor() {
        guard placeRecordEditorRouter == nil else { return }
        
        let router = placeRecordEditorBuilder.build(withListener: interactor)
        
        placeRecordEditorRouter = router
        attachChild(router)
        
        let vc = router.viewControllable.uiviewController
        vc.presentationController?.delegate = interactor.modalAdaptivePresentationControllerDelegateProxy
        
        viewControllable.uiviewController.present(vc, animated: true)
    }
    
    func detachPlaceRecordEditor() {
        guard let router = placeRecordEditorRouter else { return }
        
        router.viewControllable.uiviewController.dismiss(animated: true)
        detachChild(router)
        
        placeRecordEditorRouter = nil
    }
}
