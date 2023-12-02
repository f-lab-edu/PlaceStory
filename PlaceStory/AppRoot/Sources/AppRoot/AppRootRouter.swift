//
//  AppRootRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs

protocol AppRootInteractable: Interactable {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppRootRouter: ViewableRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppRootInteractable, viewController: AppRootViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
