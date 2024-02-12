//
//  PlaceSearcherBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs
import UseCase

public protocol PlaceSearcherDependency: Dependency {
    var mapServiceUseCase: MapServiceUseCase { get }
}

final class PlaceSearcherComponent: Component<PlaceSearcherDependency>, PlaceSearcherInteractorDependency {
    var mapServiceUseCase: MapServiceUseCase { dependency.mapServiceUseCase }
}

// MARK: - Builder

public protocol PlaceSearcherBuildable: Buildable {
    func build(withListener listener: PlaceSearcherListener) -> PlaceSearcherRouting
}

public final class PlaceSearcherBuilder: Builder<PlaceSearcherDependency>, PlaceSearcherBuildable {

    public override init(dependency: PlaceSearcherDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: PlaceSearcherListener) -> PlaceSearcherRouting {
        let component = PlaceSearcherComponent(dependency: dependency)
        let viewController = PlaceSearcherViewController()
        let interactor = PlaceSearcherInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        
        return PlaceSearcherRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
