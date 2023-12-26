//
//  LocationMarkerBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs

protocol LocationMarkerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class LocationMarkerComponent: Component<LocationMarkerDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol LocationMarkerBuildable: Buildable {
    func build(withListener listener: LocationMarkerListener) -> LocationMarkerRouting
}

final class LocationMarkerBuilder: Builder<LocationMarkerDependency>, LocationMarkerBuildable {

    override init(dependency: LocationMarkerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LocationMarkerListener) -> LocationMarkerRouting {
        let component = LocationMarkerComponent(dependency: dependency)
        let viewController = LocationMarkerViewController()
        let interactor = LocationMarkerInteractor(presenter: viewController)
        interactor.listener = listener
        return LocationMarkerRouter(interactor: interactor, viewController: viewController)
    }
}
