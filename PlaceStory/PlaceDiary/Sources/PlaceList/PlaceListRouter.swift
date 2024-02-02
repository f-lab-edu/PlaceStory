//
//  PlaceListRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import ModernRIBs

protocol PlaceListInteractable: Interactable {
    var router: PlaceListRouting? { get set }
    var listener: PlaceListListener? { get set }
}

protocol PlaceListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PlaceListRouter: ViewableRouter<PlaceListInteractable, PlaceListViewControllable>, PlaceListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PlaceListInteractable, viewController: PlaceListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
