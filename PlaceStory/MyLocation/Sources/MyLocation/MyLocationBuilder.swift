//
//  MyLocationBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import RepositoryImps
import ModernRIBs
import PlaceList
import PlaceSearcher
import UseCase
import CommonUI

public protocol MyLocationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
  var mapViewFactory: MapViewFactory { get }
}

final class MyLocationComponent: Component<MyLocationDependency>, PlaceSearcherDependency, PlaceListDependency {

    let locationServiceUseCase: LocationServiceUseCase
    
    var mapServiceUseCase: MapServiceUseCase
  
    var mapViewFactory: MapViewFactory { self.dependency.mapViewFactory }
    
    override init(
        dependency: MyLocationDependency
    ) {
        self.locationServiceUseCase = LocationServiceUseCaseImp(
            locationServiceRepository: LocationServiceRepositoryImp()
        )
        self.mapServiceUseCase = MapServiceUseCaseImp(
            mapServiceRepository: MapServiceRepositoryImp()
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
        let viewController = MyLocationViewController(mapViewFactory:   component.mapViewFactory)
        let interactor = MyLocationInteractor(
            presenter: viewController,
            locationServiceUseCase: component.locationServiceUseCase,
            mapServiceUseCase: component.mapServiceUseCase
        )
        interactor.listener = listener
        
        let placeSearchBuilder = PlaceSearcherBuilder(dependency: component)
        let placeListBuilder = PlaceListBuilder(dependency: component)
        
        return MyLocationRouter(
            interactor: interactor,
            viewController: viewController,
            placeSearcherBuilder: placeSearchBuilder,
            placeListBuilder: placeListBuilder
        )
    }
}
