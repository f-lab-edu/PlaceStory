//
//  LoggedInRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import ModernRIBs
import MyLocation

protocol LoggedInInteractable: Interactable, MyLocationListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func setViewControllers(_ viewControllables: [ViewControllable])
}

final class LoggedInRouter: ViewableRouter<LoggedInInteractable, LoggedInViewControllable>, LoggedInRouting {
    
    private let myLocationBuilder: MyLocationBuildable
    private var myLocationRouting: MyLocationRouting?
    
    init(
        interactor: LoggedInInteractable,
        viewController: LoggedInViewControllable,
        myLocationBuilder: MyLocationBuildable
    ) {
        self.myLocationBuilder = myLocationBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let myLocationRouter = myLocationBuilder.build(withListener: interactor)
        
        attachChild(myLocationRouter)
        
        let viewControllers = [
            myLocationRouter.viewControllable
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
