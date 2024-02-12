//
//  AppRootBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import AppleMapView
import ModernRIBs
import LoggedOut
import LoggedIn
import UseCase


public protocol AppRootDependency: Dependency {
    var loggedOutBuilder: LoggedOutBuildable { get }
    var loggedInBuilder: LoggedInBuildable { get }
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { get }
}

final class AppRootComponent: Component<AppRootDependency>, AppRootInteractorDependency {
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { dependency.appleAuthenticationServiceUseCase }
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
            dependency: component
        )
        
        return AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            loggedOutBuilder: dependency.loggedOutBuilder,
            loggedInBuilder: dependency.loggedInBuilder
        )
    }
}
