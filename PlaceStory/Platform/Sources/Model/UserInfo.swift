//
//  File.swift
//  
//
//  Created by 최제환 on 12/9/23.
//

import RealmSwift
import Foundation

public class UserInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var userIdentifier: String
    @Persisted var email: String
    @Persisted var name: String
    @Persisted var accessToken: String
    @Persisted var identityToken: String
    @Persisted var imgPath: String
}
