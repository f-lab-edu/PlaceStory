//
//  AppComponent.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import AppRoot
import ModernRIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
