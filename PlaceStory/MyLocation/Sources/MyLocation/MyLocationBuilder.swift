//
//  MyLocationBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import RepositoryImps
import ModernRIBs
import PlaceSearcher
import UseCase

public protocol MyLocationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyLocationComponent: Component<MyLocationDependency>, PlaceSearcherDependency {

    let locationServiceUseCase: LocationServiceUseCase
    
    override init(
        dependency: MyLocationDependency
    ) {
        self.locationServiceUseCase = LocationServiceUseCaseImp(
            locationServiceRepository: LocationServiceRepositoryImp()
        )
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol MyLocationBuildable: Buildable {
    func build(withListener listener: MyLocationListener) -> MyLocationRouting
}

public final class MyLocationBuilder: Builder<MyLocationDependency>, MyLocationBuildable {

    public override init(dependency: MyLocationDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: MyLocationListener) -> MyLocationRouting {
        let component = MyLocationComponent(dependency: dependency)
        let viewController = MyLocationViewController()
        let interactor = MyLocationInteractor(
            presenter: viewController,
            locationServiceUseCase: component.locationServiceUseCase
        )
        interactor.listener = listener
        
        let placeSearchBuilder = PlaceSearcherBuilder(dependency: component)
        
        return MyLocationRouter(
            interactor: interactor,
            viewController: viewController,
            placeSearcherBuilder: placeSearchBuilder
        )
    }
}
