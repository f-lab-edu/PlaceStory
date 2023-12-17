//
//  LoggedInBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import ModernRIBs

public protocol LoggedInDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class LoggedInComponent: Component<LoggedInDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        return LoggedInRouter(interactor: interactor, viewController: viewController)
    }
}
