//
//  PlaceListBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import ModernRIBs

public protocol PlaceListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PlaceListComponent: Component<PlaceListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol PlaceListBuildable: Buildable {
    func build(withListener listener: PlaceListListener) -> PlaceListRouting
}

public final class PlaceListBuilder: Builder<PlaceListDependency>, PlaceListBuildable {

    public override init(dependency: PlaceListDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: PlaceListListener) -> PlaceListRouting {
        let component = PlaceListComponent(dependency: dependency)
        let viewController = PlaceListViewController()
        let interactor = PlaceListInteractor(presenter: viewController)
        interactor.listener = listener
        
        return PlaceListRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
