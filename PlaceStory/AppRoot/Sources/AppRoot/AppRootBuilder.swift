//
//  AppRootBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import AppleMapView
import PlaceList
import PlaceSearcher
import Repositories
import RepositoryImps
import ModernRIBs
import MyLocation
import LocalStorage
import LoggedOut
import SecurityServices
import LoggedIn
import UseCase


public protocol AppRootDependency: Dependency {
    var loggedOutBuilder: LoggedOutBuildable { get }
    var loggedInBuilder: LoggedInBuildable { get }
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { get }
    var myLocationBuilder: MyLocationBuildable { get }
    var placeListBuilder: PlaceListBuildable { get }
    var mapViewFactory: MapViewFactory { get }
    var locationServiceUseCase: LocationServiceUseCase { get }
    var mapServiceUseCase: MapServiceUseCase { get }
    var placeSearchBuilder: PlaceSearcherBuildable { get }
}

final class AppRootComponent: Component<AppRootDependency>, LoggedOutDependency, LoggedInDependency {
    var appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase { dependency.appleAuthenticationServiceUseCase }
    var myLocationBuilder: MyLocationBuildable { dependency.myLocationBuilder }
    var mapViewFactory: MapViewFactory { dependency.mapViewFactory }
    var locationServiceUseCase: LocationServiceUseCase { dependency.locationServiceUseCase }
    var mapServiceUseCase: MapServiceUseCase { dependency.mapServiceUseCase }
    var placeSearchBuilder: PlaceSearcherBuildable { dependency.placeSearchBuilder }
    var placeListBuilder: PlaceListBuildable { dependency.placeListBuilder }
        
}

// MARK: - Builder

public protocol AppRootBuildable: Buildable {
    func build() -> LaunchRouting
}

public final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
    
    public override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }
    
    public func build() -> LaunchRouting {
        let component = AppRootComponent(dependency: dependency)
        let viewController = AppRootViewController()
        let interactor = AppRootInteractor(
            presenter: viewController,
            appleAuthenticationServiceUseCase: dependency.appleAuthenticationServiceUseCase
        )
        
        return AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            loggedOutBuilder: dependency.loggedOutBuilder,
            loggedInBuilder: dependency.loggedInBuilder
        )
    }
}
