//
//  LoggedInBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/17/23.
//

import AppleMapView
import ModernRIBs
import MyLocation
import PlaceList
import PlaceSearcher
import UseCase

public protocol LoggedInDependency: Dependency {
    var myLocationBuilder: MyLocationBuildable { get }
    var mapViewFactory: MapViewFactory { get }
    var locationServiceUseCase: LocationServiceUseCase { get }
    var mapServiceUseCase: MapServiceUseCase { get }
    var appSettingsServiceUseCase: AppSettingsServiceUseCase { get }
    var placeSearchBuilder: PlaceSearcherBuildable { get }
    var placeListBuilder: PlaceListBuildable { get }
  var appService: AppServiceUsecase { get }
}

final class LoggedInComponent: Component<LoggedInDependency> {
    var mapViewFactory: MapViewFactory { dependency.mapViewFactory }
    var locationServiceUseCase: LocationServiceUseCase { dependency.locationServiceUseCase }
    var mapServiceUseCase: MapServiceUseCase { dependency.mapServiceUseCase }
    var appSettingsServiceUseCase: AppSettingsServiceUseCase { dependency.appSettingsServiceUseCase }
    var placeSearchBuilder: PlaceSearcherBuildable { dependency.placeSearchBuilder }
    var placeListBuilder: PlaceListBuildable { dependency.placeListBuilder }
}

// MARK: - Builder

public protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener) -> LoggedInRouting
}

public final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    public override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: LoggedInListener) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency)
        let viewController = LoggedInViewController()
        let interactor = LoggedInInteractor(presenter: viewController)
        interactor.listener = listener
        
        return LoggedInRouter(
            interactor: interactor,
            viewController: viewController,
            myLocationBuilder: dependency.myLocationBuilder,
            placeListBuilder: dependency.placeListBuilder
        )
    }
}
