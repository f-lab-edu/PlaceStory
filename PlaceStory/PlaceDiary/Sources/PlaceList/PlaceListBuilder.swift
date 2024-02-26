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
    let placeName: String
    
    var placeListUsecase: PlaceListUsecase { dependency.placeListUsecase }
    
    init(
        dependency: PlaceListDependency,
        placeName: String
    ) {
        self.placeName = placeName
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol PlaceListBuildable: Buildable {
    func build(withListener listener: PlaceListListener, placeName: String) -> PlaceListRouting
}

public final class PlaceListBuilder: Builder<PlaceListDependency>, PlaceListBuildable {
    
    public override init(dependency: PlaceListDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: PlaceListListener, placeName: String) -> PlaceListRouting {
        let component = PlaceListComponent(dependency: dependency, placeName: placeName)
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
