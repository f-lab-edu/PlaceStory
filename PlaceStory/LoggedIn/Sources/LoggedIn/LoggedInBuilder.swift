//
//  LoggedInBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import ModernRIBs
import MyLocation
import PlaceList

public protocol LoggedInDependency: Dependency {
    var myLocationBuilder: MyLocationBuildable { get }
    var placeListBuilder: PlaceListBuildable { get }
}

final class LoggedInComponent: Component<LoggedInDependency>, LoggedInInteractorDependency {
    let userID: String
    
    init(
        dependency: LoggedInDependency,
        userID: String
    ) {
        self.userID = userID
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener, userID: String) -> LoggedInRouting
}

public final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {
    
    public override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: LoggedInListener, userID: String) -> LoggedInRouting {
        let component = LoggedInComponent(
            dependency: dependency,
            userID: userID
        )
        let viewController = LoggedInViewController()
        let interactor = LoggedInInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        
        return LoggedInRouter(
            interactor: interactor,
            viewController: viewController,
            myLocationBuilder: dependency.myLocationBuilder,
            placeListBuilder: dependency.placeListBuilder
        )
    }
}
