//
//  AppRootBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import ModernRIBs

protocol AppRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build(withListener listener: AppRootListener) -> AppRootRouting
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppRootListener) -> AppRootRouting {
        let component = AppRootComponent(dependency: dependency)
        let viewController = AppRootViewController()
        let interactor = AppRootInteractor(presenter: viewController)
        interactor.listener = listener
        return AppRootRouter(interactor: interactor, viewController: viewController)
    }
}
