//
//  LocationMarkerRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs

protocol LocationMarkerInteractable: Interactable {
    var router: LocationMarkerRouting? { get set }
    var listener: LocationMarkerListener? { get set }
}

protocol LocationMarkerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LocationMarkerRouter: ViewableRouter<LocationMarkerInteractable, LocationMarkerViewControllable>, LocationMarkerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: LocationMarkerInteractable, viewController: LocationMarkerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
