//
//  AppRootRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs
import LoggedOut
import LoggedIn

protocol AppRootInteractable: Interactable, LoggedOutListener, LoggedInListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouter: LoggedInRouting?

    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        loggedOutBuilder: LoggedOutBuildable,
        loggedInBuilder: LoggedInBuildable
    ) {
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        
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
    
    func detachLoggedOut() {
        guard let router = loggedOutRouter else { return }
        
        viewController.dismiss(viewController: router.viewControllable)
        detachChild(router)
        loggedOutRouter = nil
    }
    
    func attachLoggedIn() {
        guard loggedInRouter == nil else { return }
        
        let router = loggedInBuilder.build(withListener: interactor)
        loggedInRouter = router
        attachChild(router)
        
        viewController.present(viewController: router.viewControllable)
    }
}
