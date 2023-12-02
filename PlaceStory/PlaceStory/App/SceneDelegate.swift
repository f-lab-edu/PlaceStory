//
//  SceneDelegate.swift
//  PlaceStory
//
//  Created by 최제환 on 12/1/23.
//

import AppRoot
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var launchRouter: AppRootRouter?
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let launchRouter = AppRootRouter(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launchFromWindow(window)
    }
}

