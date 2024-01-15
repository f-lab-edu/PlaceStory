//
//  PlaceSearcherRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs

public protocol PlaceSearcherInteractable: Interactable {
    var router: PlaceSearcherRouting? { get set }
    var listener: PlaceSearcherListener? { get set }
}

protocol PlaceSearcherViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PlaceSearcherRouter: ViewableRouter<PlaceSearcherInteractable, PlaceSearcherViewControllable>, PlaceSearcherRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PlaceSearcherInteractable, viewController: PlaceSearcherViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
