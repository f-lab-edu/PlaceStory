//
//  File.swift
//  
//
//  Created by 최제환 on 12/6/23.
//

import Foundation

public struct AppleUser {
    public let userIdentifier: String
    public let email: String
    public let name: String
    public let accessToken: String
    public let identityToken: String
    public let imgPath: Data?
    
    public init(
        userIdentifier: String,
        email: String,
        name: String,
        accessToken: String,
        identityToken: String,
        imgPath: Data?
    ) {
        self.userIdentifier = userIdentifier
        self.email = email
        self.name = name
        self.accessToken = accessToken
        self.identityToken = identityToken
        self.imgPath = imgPath
    }
}
