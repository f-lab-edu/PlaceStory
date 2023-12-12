//
//  LoggedOutBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs
import UseCase

public protocol LoggedOutDependency: Dependency {
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

public final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    public override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component = LoggedOutComponent(dependency: dependency)
        let viewController = LoggedOutViewController()
        let interactor = LoggedOutInteractor(
            presenter: viewController,
            appleAuthenticationServiceUseCase: dependency.appleAuthenticationServiceUseCase
        )
        interactor.listener = listener
        
        return LoggedOutRouter(interactor: interactor, viewController: viewController)
    }
}
