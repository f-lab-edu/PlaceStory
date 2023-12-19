//
//  AppRootBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import Repositories
import RepositoryImps
import ModernRIBs
import LocalStorage
import LoggedOut
import SecurityServices
import UseCase


public protocol AppRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency>, LoggedOutDependency {
    let appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase
    let appleAuthenticationServiceRepository: AppleAuthenticationServiceRepository
    
    override init(
        dependency: AppRootDependency
    ) {
        let realmDatabase = RealmDatabaseImp()
        let keychainService = KeychainServiceImp()
        self.appleAuthenticationServiceRepository = AppleAuthenticationServiceRepositoryImp(
            database: realmDatabase,
            keychain: keychainService
        )
        self.appleAuthenticationServiceUseCase = AppleAuthenticationServiceUseCaseImp(
            appleAuthenticationServiceRepository: AppleAuthenticationServiceRepositoryImp(
                database: realmDatabase,
                keychain: keychainService
            )
        )
        
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
            appleAuthenticationServiceUseCase: component.appleAuthenticationServiceUseCase,
            appleAuthenticationServiceRepository: component.appleAuthenticationServiceRepository
        )
        
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        
        let router = AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            loggedOutBuilder: loggedOutBuilder
        )
        
        return router
    }
}
