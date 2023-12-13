//
//  File.swift
//  
//
//  Created by 최제환 on 12/11/23.
//

import Foundation
import RealmSwift
import Model

public final class RealmMigrationManager {
    static func performMigration() -> Realm.Configuration {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: UserInfo.className()) { oldObject, newObject in
                        if let oldString = oldObject?["imgPath"] as? String,
                           let data = oldString.data(using: .utf8) {
                            newObject?["imgPath"] = data
                        }
                    }
                }
                
            }
        )
        
        return config
    }
}
