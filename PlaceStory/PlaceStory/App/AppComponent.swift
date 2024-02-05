//
//  AppComponent.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import AppRoot
import ModernRIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
  
    lazy var loggedInBuildable: LoggedInBuildable = LoggedInBuilder(dependency: self)
  lazy var loggedOutBuildable: LoggedOutBuildable = LoggedOutBuilder(dependency: self)
  lazy var myLocationBuildable: MyLocationBuildable = MyLocationBuildable)
  
  let mapViewFactory: MapViewFactory
    init() {
        super.init(dependency: EmptyComponent())
      
      
      self.mapViewFactory = MapViewFactoryImp()
      
    }
}
