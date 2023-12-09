//
//  File.swift
//  
//
//  Created by 최제환 on 12/6/23.
//

import Foundation

public struct AppleUser {
    let userIdentifier: String
    let email: String
    let name: String
    let accessToken: String
    let identityToken: String
    let imgPath: String
    
    public init(
        userIdentifier: String,
        email: String,
        name: String,
        accessToken: String,
        identityToken: String,
        imgPath: String
    ) {
        self.userIdentifier = userIdentifier
        self.email = email
        self.name = name
        self.accessToken = accessToken
        self.identityToken = identityToken
        self.imgPath = imgPath
    }
}
