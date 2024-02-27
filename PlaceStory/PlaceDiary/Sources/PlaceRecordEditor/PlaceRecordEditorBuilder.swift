//
//  PlaceRecordEditorBuilder.swift
//  PlaceStory
//
//  Created by 최제환 on 2/27/24.
//

import ModernRIBs

public protocol PlaceRecordEditorDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PlaceRecordEditorComponent: Component<PlaceRecordEditorDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol PlaceRecordEditorBuildable: Buildable {
    func build(withListener listener: PlaceRecordEditorListener) -> PlaceRecordEditorRouting
}

public final class PlaceRecordEditorBuilder: Builder<PlaceRecordEditorDependency>, PlaceRecordEditorBuildable {

    public override init(dependency: PlaceRecordEditorDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: PlaceRecordEditorListener) -> PlaceRecordEditorRouting {
        let component = PlaceRecordEditorComponent(dependency: dependency)
        let viewController = PlaceRecordEditorViewController()
        let interactor = PlaceRecordEditorInteractor(presenter: viewController)
        interactor.listener = listener
        return PlaceRecordEditorRouter(interactor: interactor, viewController: viewController)
    }
}
