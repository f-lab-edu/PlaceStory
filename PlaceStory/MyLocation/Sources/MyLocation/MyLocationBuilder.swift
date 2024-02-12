//
//  MyLocationBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import AppleMapView
import RepositoryImps
import ModernRIBs
import PlaceList
import PlaceSearcher
import UseCase

public protocol MyLocationDependency: Dependency {
    var locationServiceUseCase: LocationServiceUseCase { get }
    var mapServiceUseCase: MapServiceUseCase { get }
    var appSettingsServiceUseCase: AppSettingsServiceUseCase { get }
    var mapViewFactory: MapViewFactory { get }
    var placeSearchBuilder: PlaceSearcherBuildable { get }
    var placeListBuilder: PlaceListBuildable { get }
}

final class MyLocationComponent: Component<MyLocationDependency>, MyLocationInteractorDependency {
    var locationServiceUseCase: LocationServiceUseCase { dependency.locationServiceUseCase }
    var mapServiceUseCase: MapServiceUseCase { dependency.mapServiceUseCase }
    var appSettingsServiceUseCase: AppSettingsServiceUseCase { dependency.appSettingsServiceUseCase }
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
        let viewController = MyLocationViewController(mapViewFactory: dependency.mapViewFactory)
        let interactor = MyLocationInteractor(
            presenter: viewController,
            dependency: component
        )
        
        interactor.listener = listener
        
        return MyLocationRouter(
            interactor: interactor,
            viewController: viewController,
            placeSearcherBuilder: dependency.placeSearchBuilder,
            placeListBuilder: dependency.placeListBuilder
        )
    }
}
