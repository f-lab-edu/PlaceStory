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

enum RealmDatabaseError: Error {
    case objectNotFound
    
    var errorDescription: String {
        switch self {
        case .objectNotFound:
            return "주어진 ID에 해당하는 객체를 찾을 수 없습니다"
        }
    }
}

protocol RealmDatabase {
    func create<T: Object>(_ object: T)
    func read<T: Object>(_ object: T.Type, forKey key: ObjectId) -> T?
    func update<T: Object>(_ object: T.Type, forKey key: ObjectId, with updateData: [String: Any]) -> AnyPublisher<T, Error>
    func delete<T: Object>(_ object: T)
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
    
    public func create<T>(_ object: T) where T : Object {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            Log.error(error.localizedDescription, "[\(#file)-\(#function) - \(#line)]")
        }
    }
    
    public func read<T>(
        _ object: T.Type,
        forKey key: ObjectId
    ) -> T? where T : Object {
        let realm = try! Realm()
        
        return realm.objects(object).first
    }
    
    public func update<T>(
        _ object: T.Type,
        forKey key: ObjectId,
        with updateData: [String : Any]
    ) -> AnyPublisher<T, Error> where T : Object {
        do {
            let realm = try! Realm()
            
            if let objectToUpdate = realm.object(ofType: object, forPrimaryKey: key) {
                try realm.write {
                    for (key, value) in updateData {
                        objectToUpdate.setValue(value, forKey: key)
                    }
                }
                return Just(objectToUpdate).setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                Log.error(RealmDatabaseError.objectNotFound.errorDescription, "[\(#file)-\(#function) - \(#line)]")
                return Fail(error: RealmDatabaseError.objectNotFound)
                    .eraseToAnyPublisher()
            }
        } catch {
            Log.error(error.localizedDescription, "[\(#file)-\(#function) - \(#line)]")
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    public func delete<T>(_ object: T) where T : Object {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            Log.error(error.localizedDescription, "[\(#file)-\(#function) - \(#line)]")
        }
    }
}
