//
//  PlaceSearcherBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs

protocol PlaceSearcherDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PlaceSearcherComponent: Component<PlaceSearcherDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PlaceSearcherBuildable: Buildable {
    func build(withListener listener: PlaceSearcherListener) -> PlaceSearcherRouting
}

final class PlaceSearcherBuilder: Builder<PlaceSearcherDependency>, PlaceSearcherBuildable {

    override init(dependency: PlaceSearcherDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PlaceSearcherListener) -> PlaceSearcherRouting {
        let component = PlaceSearcherComponent(dependency: dependency)
        let viewController = PlaceSearcherViewController()
        let interactor = PlaceSearcherInteractor(presenter: viewController)
        interactor.listener = listener
        return PlaceSearcherRouter(interactor: interactor, viewController: viewController)
    }
}
