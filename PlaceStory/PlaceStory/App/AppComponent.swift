//
//  AppComponent.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import AppRoot
import AppleMapView
import LocalStorage
import LoggedOut
import LoggedIn
import MyLocation
import ModernRIBs
import PlaceSearcher
import PlaceList
import PlaceRecordEditor
import Repositories
import RepositoryImps
import SecurityServices
import UseCase

final class AppComponent: Component<EmptyDependency>, AppRootDependency, LoggedOutDependency, LoggedInDependency, MyLocationDependency, PlaceSearcherDependency, PlaceListDependency, PlaceRecordEditorDependency {
    let appleAuthenticationServiceUseCase: AppleAuthenticationServiceUseCase
    let mapViewFactory: MapViewFactory
    let locationServiceUseCase: LocationServiceUseCase
    let mapServiceUseCase: MapServiceUseCase
    let appSettingsServiceUseCase: AppSettingsServiceUseCase
    let placeListUsecase: PlaceListUsecase
    
    lazy var loggedOutBuilder: LoggedOutBuildable = LoggedOutBuilder(dependency: self)
    lazy var loggedInBuilder: LoggedInBuildable = LoggedInBuilder(dependency: self)
    lazy var myLocationBuilder: MyLocationBuildable = MyLocationBuilder(dependency: self)
    lazy var placeListBuilder: PlaceListBuildable = PlaceListBuilder(dependency: self)
    lazy var placeSearchBuilder: PlaceSearcherBuildable = PlaceSearcherBuilder(dependency: self)
    lazy var placeRecordEditorBuilder: PlaceRecordEditorBuildable = PlaceRecordEditorBuilder(dependency: self)
    
    init() {
        let realmDatabaseImp = RealmDatabaseImp()
        let keychainService = KeychainServiceImp()
        let appleAuthenticationServiceRepositoryImp = AppleAuthenticationServiceRepositoryImp()
        let appleAuthenticationServiceUseCaseImp = AppleAuthenticationServiceUseCaseImp(appleAuthenticationServiceRepository: appleAuthenticationServiceRepositoryImp)
        self.appleAuthenticationServiceUseCase = appleAuthenticationServiceUseCaseImp
        
        self.mapViewFactory = MapViewFactoryImp()
        
        let locationServiceRepositoryImp = LocationServiceRepositoryImp()
        let locationServiceUseCaseImp =  LocationServiceUseCaseImp(locationServiceRepository: locationServiceRepositoryImp)
        self.locationServiceUseCase = locationServiceUseCaseImp
        
        let mapServiceRepositoryImp = MapServiceRepositoryImp()
        let mapServiceUsecaseImp = MapServiceUseCaseImp(mapServiceRepository: mapServiceRepositoryImp)
        self.mapServiceUseCase = mapServiceUsecaseImp
        
        self.appSettingsServiceUseCase = .live
        
        let placeListRepository = PlaceListRepositoryImp(database: realmDatabaseImp, keychain: keychainService)
        self.placeListUsecase = PlaceListUsecaseImp(placeListRepository: placeListRepository)
        
        super.init(dependency: EmptyComponent())
    }
}
