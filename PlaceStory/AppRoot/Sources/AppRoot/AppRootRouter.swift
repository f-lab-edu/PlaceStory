//
//  AppRootRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs
import LoggedOut

protocol AppRootInteractable: Interactable, LoggedOutListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?

    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        loggedOutBuilder: LoggedOutBuildable
    ) {
        self.loggedOutBuilder = loggedOutBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachLoggedOut() {
        guard loggedOutRouter == nil else { return }
        let router = loggedOutBuilder.build(withListener: interactor)
        loggedOutRouter = router
        attachChild(router)
        
        viewController.present(viewController: router.viewControllable)
    }
}
