//
//  MyLocationRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import ModernRIBs

protocol MyLocationInteractable: Interactable {
    var router: MyLocationRouting? { get set }
    var listener: MyLocationListener? { get set }
}

protocol MyLocationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyLocationRouter: ViewableRouter<MyLocationInteractable, MyLocationViewControllable>, MyLocationRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MyLocationInteractable, viewController: MyLocationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
