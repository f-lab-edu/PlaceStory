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

final class LoggedOutComponent: Component<LoggedOutDependency>, LoggedOutInteractorDependency {
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { dependency.appleAuthenticationServiceUseCase }
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
            dependency: component
        )
        interactor.listener = listener
        
        return LoggedOutRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
