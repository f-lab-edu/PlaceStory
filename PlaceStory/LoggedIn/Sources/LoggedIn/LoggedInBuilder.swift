//
//  LoggedInBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import ModernRIBs
import MyLocation

public protocol LoggedInDependency: Dependency {
    
}

final class LoggedInComponent: Component<LoggedInDependency>, MyLocationDependency {
    
}

// MARK: - Builder

public protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener) -> LoggedInRouting
}

public final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    public override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: LoggedInListener) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency)
        let viewController = LoggedInViewController()
        let interactor = LoggedInInteractor(presenter: viewController)
        interactor.listener = listener
        
        let myLocationBuilder = MyLocationBuilder(dependency: component)
        
        return LoggedInRouter(
            interactor: interactor,
            viewController: viewController,
            myLocationBuilder: myLocationBuilder
        )
    }
}
