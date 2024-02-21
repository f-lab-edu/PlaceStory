//
//  PlaceListBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 1/30/24.
//

import ModernRIBs
import UseCase
import Utils

public protocol PlaceListDependency: Dependency {
    var placeListUsecase: PlaceListUsecase { get }
}

final class PlaceListComponent: Component<PlaceListDependency>, PlaceListInteractorDependency {
    var placeListUsecase: PlaceListUsecase { dependency.placeListUsecase }
    var placeNamePublisher: CurrentPublisher<String>
    
    init(
        dependency: PlaceListDependency,
        placeNamePublisher: CurrentPublisher<String>
    ) {
        self.placeNamePublisher = placeNamePublisher
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol PlaceListBuildable: Buildable {
    func build(withListener listener: PlaceListListener, placeNamePublisher: CurrentPublisher<String>) -> PlaceListRouting
}

public final class PlaceListBuilder: Builder<PlaceListDependency>, PlaceListBuildable {
    
    public override init(dependency: PlaceListDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: PlaceListListener, placeNamePublisher: CurrentPublisher<String>) -> PlaceListRouting {
        let component = PlaceListComponent(dependency: dependency, placeNamePublisher: placeNamePublisher)
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
