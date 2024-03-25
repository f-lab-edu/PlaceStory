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
        
        let vc = router.viewControllable.uiviewController
        vc.modalPresentationStyle = .fullScreen
        
        viewControllable.uiviewController.present(vc, animated: true)
    }
    
    func detachLoggedOut() {
        guard let router = loggedOutRouter else { return }
        
        viewControllable.uiviewController.dismiss(animated: false)
        
        detachChild(router)
        loggedOutRouter = nil
    }
    
    func attachLoggedIn(with userID: String) {
        guard loggedInRouter == nil else { return }
        
        let router = loggedInBuilder.build(withListener: interactor, userID: userID)
        loggedInRouter = router
        attachChild(router)
        
        let vc = router.viewControllable.uiviewController
        vc.modalPresentationStyle = .fullScreen
        
        viewControllable.uiviewController.present(vc, animated: true)
    }
}
