//
//  File.swift
//  
//
//  Created by 최제환 on 2/6/24.
//

import Combine
import Entities
import Foundation
import LocalStorage
import Model
import Repositories
import RealmSwift
import SecurityServices
import Utils

public final class PlaceListRepositoryImp {
    
    private let placeRecordSubject = CurrentValueSubject<[PlaceRecord], RealmDatabaseError>([])
    private let database: RealmDatabaseImp
    private let keychain: KeychainServiceImp
    
    public init(
        database: RealmDatabaseImp,
        keychain: KeychainServiceImp
    ) {
        self.database = database
        self.keychain = keychain
    }
    
    private func convertToPlaceRecordInfo(_ placeRecord: PlaceRecord) -> PlaceRecordInfo {
        let placeRecordInfo = PlaceRecordInfo()
        placeRecordInfo.id = database.convertObjectId(from: placeRecord.id)
        placeRecordInfo.userId = placeRecord.userId
        placeRecordInfo.placeName = placeRecord.placeName
        placeRecordInfo.recordTitle = placeRecord.recordTitle
        placeRecordInfo.recordDescription = placeRecord.recordDescription
        placeRecordInfo.placeCategory = placeRecord.placeCategory
        placeRecordInfo.registerDate = placeRecord.registerDate
        placeRecordInfo.updateDate = placeRecord.updateDate
        if let recordImages = placeRecord.recordImages {
            placeRecordInfo.recordImages.append(objectsIn: recordImages)
        }
        
        return placeRecordInfo
    }
    
    private func convertObjectToDictionary(from object: Object) -> [String: Any] {
        let mirror = Mirror(reflecting: object)
        
        var dict = [String: Any]()
        for child in mirror.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        
        return dict
    }
}

// MARK: - PlaceListRepository

extension PlaceListRepositoryImp: PlaceListRepository {
    public func fetchPlaceRecordFrom(userId: String, placeName: String) -> AnyPublisher<[PlaceRecord], RealmDatabaseError> {
        let result = database.read(PlaceRecordInfo.self, userId: userId, placeName: placeName)
        
        switch result {
        case .success(let placeRecordInfos):
            let placeRecords = placeRecordInfos.map { $0.toDomain() }
            placeRecordSubject.send(placeRecords)
            
        case .failure(let realmDatabaseError):
            placeRecordSubject.send(completion: .failure(realmDatabaseError))
        }
        
        return placeRecordSubject.eraseToAnyPublisher()
    }
    
    public func insert(placeRecord: PlaceRecord) -> Bool {
        let placeRecordInfo = convertToPlaceRecordInfo(placeRecord)
        let result = database.create(placeRecordInfo)
        
        switch result {
        case .success(let success):
            return success
            
        case .failure:
            return false
        }
    }
    
    public func update(placeRecord: PlaceRecord) -> Bool {
        let placeRecordInfo = convertToPlaceRecordInfo(placeRecord)
        let placeReCordInfoDictionary = convertObjectToDictionary(from: placeRecordInfo)
        
        let result = database.update(PlaceRecordInfo.self, forKey: placeRecordInfo.id, with: placeReCordInfoDictionary)
        
        switch result {
        case .success(let success):
            return success
            
        case .failure:
            return false
        }
    }
    
    public func delete(placeRecord: PlaceRecord) -> Bool {
        let placeRecordInfo = convertToPlaceRecordInfo(placeRecord)
        let result = database.delete(placeRecordInfo)
        
        switch result {
        case .success(let success):
            return success
            
        case .failure:
            return false
        }
    }
}
