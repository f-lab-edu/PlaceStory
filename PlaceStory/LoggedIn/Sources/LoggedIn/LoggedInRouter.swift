//
//  LoggedInRouter.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import ModernRIBs
import MyLocation
import PlaceList

protocol LoggedInInteractable: Interactable, MyLocationListener, PlaceListListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func setViewControllers(_ viewControllables: [ViewControllable])
}

final class LoggedInRouter: ViewableRouter<LoggedInInteractable, LoggedInViewControllable>, LoggedInRouting {
    
    private let myLocationBuilder: MyLocationBuildable
    private var myLocationRouting: MyLocationRouting?
    
    private let placeListBuilder: PlaceListBuildable
    private var placeListRouting: PlaceListRouting?
    
    init(
        interactor: LoggedInInteractable,
        viewController: LoggedInViewControllable,
        myLocationBuilder: MyLocationBuildable,
        placeListBuilder: PlaceListBuildable
    ) {
        self.myLocationBuilder = myLocationBuilder
        self.placeListBuilder = placeListBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let myLocationRouter = myLocationBuilder.build(withListener: interactor)
        let placeRouter = placeListBuilder.build(withListener: interactor)
        
        attachChild(myLocationRouter)
        attachChild(placeRouter)
        
        let viewControllers = [
            myLocationRouter.viewControllable,
            placeRouter.viewControllable
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
