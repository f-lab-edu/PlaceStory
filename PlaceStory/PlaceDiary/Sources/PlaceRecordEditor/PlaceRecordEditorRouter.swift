//
//  PlaceRecordEditorRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 2/27/24.
//

import ModernRIBs

protocol PlaceRecordEditorInteractable: Interactable {
    var router: PlaceRecordEditorRouting? { get set }
    var listener: PlaceRecordEditorListener? { get set }
}

protocol PlaceRecordEditorViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PlaceRecordEditorRouter: ViewableRouter<PlaceRecordEditorInteractable, PlaceRecordEditorViewControllable>, PlaceRecordEditorRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PlaceRecordEditorInteractable, viewController: PlaceRecordEditorViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
