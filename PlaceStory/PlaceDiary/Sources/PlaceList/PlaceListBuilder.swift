//
//  PlaceListBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import ModernRIBs
import UseCase

public protocol PlaceListDependency: Dependency {
    var placeListUsecase: PlaceListUsecase { get }
}

final class PlaceListComponent: Component<PlaceListDependency>, PlaceListInteractorDependency {
    var placeListUsecase: PlaceListUsecase { dependency.placeListUsecase }
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
        let interactor = PlaceListInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        
        return PlaceListRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
