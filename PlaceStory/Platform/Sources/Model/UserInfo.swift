//
//  File.swift
//  
//
//  Created by 최제환 on 12/9/23.
//

import Entities
import RealmSwift
import Foundation

public class UserInfo: Object {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var userIdentifier: String
    @Persisted public var email: String
    @Persisted public var name: String
    @Persisted public var accessToken: String
    @Persisted public var identityToken: String
    @Persisted public var imgPath: Data?
}

extension UserInfo {
    public func toDomain() -> AppleUser {
        return AppleUser(
            userIdentifier: userIdentifier,
            email: email,
            name: name,
            accessToken: accessToken,
            identityToken: identityToken,
            imgPath: imgPath
        )
    }
}
