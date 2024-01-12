//
//  File.swift
//  
//
//  Created by 최제환 on 1/12/24.
//

import Combine
import CommonUI
import CoreLocation
import Entities
import Foundation
import Repositories
import ModernRIBs
import UseCase
import UIKit
@testable import PlaceSearcher

// MARK: - PlaceSearcherBuildable Mock
final class PlaceSearcherBuildableMock: PlaceSearcherBuildable {
    
    var buildHandler:((_ listener: PlaceSearcherListener) -> PlaceSearcherRouting)?
    var buildCallCount = 0
    
    func build(withListener listener: PlaceSearcher.PlaceSearcherListener) -> PlaceSearcher.PlaceSearcherRouting {
        buildCallCount += 1
        if let buildHandler {
            return buildHandler(listener)
        }
        fatalError("Function build returns a value that can't be handled with a default value and its handler must be set")
    }
}

final class PlaceSearcherInteractableMock: PlaceSearcherInteractable {
    var router: PlaceSearcherRouting? { didSet { routerSetCallCount += 1 } }
    var routerSetCallCount = 0
    
    var listener: PlaceSearcherListener? { didSet { listenerSetCallCount += 1 } }
    var listenerSetCallCount = 0
    
    var activateHandler: (() -> ())?
    var activateCallCount = 0
    
    var deactivateHandler: (() -> ())?
    var deactivateCallCount = 0
    
    var isActive: Bool = false { didSet { isActiveSetCallCount += 1 } }
    var isActiveSetCallCount = 0
    
    var isActiveStreamSubject: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>() { didSet { isActiveStreamSubjectSetCallCount += 1 } }
    var isActiveStreamSubjectSetCallCount = 0
    var isActiveStream: AnyPublisher<Bool, Never> { return isActiveStreamSubject.eraseToAnyPublisher() }
    
    init() {}
    
    func activate() {
        activateCallCount += 1
        if let activateHandler {
            return activateHandler()
        }
    }
    
    func deactivate() {
        deactivateCallCount += 1
        if let deactivateHandler {
            return deactivateHandler()
        }
    }
}

// MARK: - PlaceSearcherRoutingMock
final class PlaceSearcherRoutingMock: PlaceSearcherRouting {
    var viewControllable: ViewControllable
    
    var interactable: Interactable { didSet { interactableSetCallCount += 1 } }
    var interactableSetCallCount = 0
    
    var children: [Routing] = [Routing]() { didSet { childrenSetCallCount += 1 } }
    var childrenSetCallCount = 0
    
    var lifecycleSubject: PassthroughSubject<RouterLifecycle, Never> = PassthroughSubject<RouterLifecycle, Never>() { didSet { lifecycleSubjectSetCallCount += 1 } }
    var lifecycleSubjectSetCallCount = 0
    var lifecycle: AnyPublisher<RouterLifecycle, Never> { return lifecycleSubject.eraseToAnyPublisher() }
    
    var loadHandler: (() -> ())?
    var loadCallCount: Int = 0
    
    var attachChildHandler: ((_ child: Routing) -> ())?
    var attachChildCallCount = 0
    
    var detachChildHandler: ((_ child: Routing) -> ())?
    var detachChildCallCount = 0
    
    init(
        interactable: Interactable,
        viewControllable: ViewControllable
    ) {
        self.interactable = interactable
        self.viewControllable = viewControllable
    }
    
    func load() {
        loadCallCount += 1
        loadHandler?()
    }
    
    func attachChild(_ child: Routing) {
        attachChildCallCount += 1
        attachChildHandler?(child)
    }
    
    func detachChild(_ child: Routing) {
        detachChildCallCount += 1
        detachChildHandler?(child)
    }
}

final class PlaceSearcherViewControllableMock: PlaceSearcherViewControllable {
    var uiviewController: UIViewController = UIViewController() { didSet { uiviewControllerSetCallCount += 1 } }
    var uiviewControllerSetCallCount = 0
}
