//
//  AppRootBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import Repositories
import RepositoryImps
import ModernRIBs
import LoggedOut
import LoggedIn
import UseCase

public protocol AppRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency>, LoggedOutDependency, LoggedInDependency {
    let appleAuthenticationServiceUseCase: UseCase.AppleAuthenticationServiceUseCase
    
    override init(
        dependency: AppRootDependency
    ) {
        self.appleAuthenticationServiceUseCase = AppleAuthenticationServiceUseCaseImp(appleAuthenticationServiceRepository: AppleAuthenticationServiceRepositoryImp())
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol AppRootBuildable: Buildable {
    func build() -> LaunchRouting
}

public final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    public override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    public func build() -> LaunchRouting {
        let component = AppRootComponent(dependency: dependency)
        let viewController = AppRootViewController()
        let interactor = AppRootInteractor(
            presenter: viewController,
            appleAuthenticationServiceUseCase: component.appleAuthenticationServiceUseCase
        )
        
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        
        let router = AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            loggedOutBuilder: loggedOutBuilder,
            loggedInBuilder: loggedInBuilder
        )
        
        return router
    }
}
