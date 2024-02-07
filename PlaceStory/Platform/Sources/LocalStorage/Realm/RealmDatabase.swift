//
//  File.swift
//  
//
//  Created by 최제환 on 12/8/23.
//

import Combine
import Foundation
import Model
import RealmSwift
import Utils

public enum RealmDatabaseError: Error {
    case objectNotFound
    case createFailed
    case readFailed
    case updateFailed
    case deleteFailed

    var errorDescription: String {
        switch self {
        case .objectNotFound:
            return "주어진 ID에 해당하는 객체를 찾을 수 없습니다"
        case .createFailed:
            return "객체 생성에 실패하였습니다"
        case .readFailed:
            return "객체 조회에 실패하였습니다"
        case .updateFailed:
            return "객체 업데이트에 실패하였습니다"
        case .deleteFailed:
            return "객체 삭제에 실패하였습니다"
        }
    }
}


protocol RealmDatabase {
    func convertObjectId(from id: String) -> ObjectId
    func create<T: Object>(_ object: T) -> Result<Bool, RealmDatabaseError>
    func read<T: Object>(_ object: T.Type, forKey key: ObjectId) -> Result<T?, RealmDatabaseError>
    func read<T: Object>(_ object: T.Type, userId: String, placeName: String) -> Result<[T], RealmDatabaseError>
    func update<T: Object>(_ object: T.Type, forKey key: ObjectId, with updateData: [String: Any]) -> Result<Bool, RealmDatabaseError>
    func delete<T: Object>(_ object: T) -> Result<Bool, RealmDatabaseError>
}

public final class RealmDatabaseImp: RealmDatabase {
    public init() {
        let config = RealmMigrationManager.performMigration()
        Realm.Configuration.defaultConfiguration = config
        
        self.realmLocation()
    }

    private func realmLocation() {
        let realm = try! Realm()
        Log.info("\(realm.configuration.fileURL!)", "[\(#file)-\(#function) - \(#line)]")
    }
    
    public func convertObjectId(from id: String) -> ObjectId {
        return try! ObjectId(string: id)
    }
    
    public func create<T>(
        _ object: T
    ) -> Result<Bool, RealmDatabaseError> where T : Object {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(object)
            }
            
            return .success(true)
        } catch {
            Log.error(error.localizedDescription, "[\(#file)-\(#function) - \(#line)]")
            return .failure(RealmDatabaseError.createFailed)
        }
    }
    
    public func read<T>(
        _ object: T.Type,
        forKey key: ObjectId
    ) -> Result<T?, RealmDatabaseError> where T : Object {
        let realm = try! Realm()
        
        return .success(realm.objects(object).first)
    }
    
    public func read<T>(
        _ object: T.Type,
        userId: String,
        placeName: String
    ) -> Result<[T], RealmDatabaseError> where T: Object {
        do {
            let realm = try Realm()
            
            let results = realm.objects(object)
                .filter("userId == %@ AND placeName == %@", userId, placeName)
            
            return .success(Array(results))
        }catch {
            Log.error(error.localizedDescription, "[\(#file)-\(#function) - \(#line)]")
            return .failure(RealmDatabaseError.readFailed)
        }
    }
    
    public func update<T>(
        _ object: T.Type,
        forKey key: ObjectId,
        with updateData: [String : Any]
    ) -> Result<Bool, RealmDatabaseError> where T : Object {
        do {
            let realm = try Realm()
            
            if let objectToUpdate = realm.object(ofType: object, forPrimaryKey: key) {
                Log.info("변경 전 객체: \(objectToUpdate)", "[\(#file)-\(#function) - \(#line)]")
                try realm.write {
                    for (key, value) in updateData {
                        objectToUpdate.setValue(value, forKey: key)
                    }
                }
                Log.info("변경 후 객체: \(objectToUpdate)", "[\(#file)-\(#function) - \(#line)]")
                return .success(true)
            } else {
                Log.error(RealmDatabaseError.objectNotFound.errorDescription, "[\(#file)-\(#function) - \(#line)]")
                return .failure(RealmDatabaseError.objectNotFound)
            }
        } catch {
            Log.error(error.localizedDescription, "[\(#file)-\(#function) - \(#line)]")
            return .failure(RealmDatabaseError.updateFailed)
        }
    }
    
    public func delete<T>(
        _ object: T
    ) -> Result<Bool, RealmDatabaseError> where T : Object {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(object)
            }
            
            return .success(true)
        } catch {
            Log.error(error.localizedDescription, "[\(#file)-\(#function) - \(#line)]")
            return .failure(RealmDatabaseError.deleteFailed)
        }
    }
}
