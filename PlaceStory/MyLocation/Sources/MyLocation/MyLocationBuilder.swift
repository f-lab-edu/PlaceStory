//
//  MyLocationBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 12/18/23.
//

import ModernRIBs

public protocol MyLocationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyLocationComponent: Component<MyLocationDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = MyLocationInteractor(presenter: viewController)
        interactor.listener = listener
        return MyLocationRouter(interactor: interactor, viewController: viewController)
    }
}
