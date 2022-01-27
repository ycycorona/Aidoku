//
//  SceneDelegate.swift
//  Aidoku (iOS)
//
//  Created by Skitty on 12/29/21.
//

import UIKit
import SwiftUI

// needed in order to fix a swiftui bug
// (using a hosting controller inside a normal nav controller would change the tab bar title)
class FixedTitleNavigationController: UINavigationController {
    var fixTitle = false
    var oldTitle: String? = nil
    
    override var title: String? {
        didSet {
            if fixTitle {
                fixTitle = false
                navigationItem.title = title
                title = oldTitle
            }
        }
        willSet {
            if newValue != tabBarItem.title && tabBarItem.title != nil {
                fixTitle = true
                oldTitle = tabBarItem.title
            }
        }
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let tabController = UITabBarController()
        let libraryViewController = HostingController(rootView: LibraryView())
        let browseViewController = FixedTitleNavigationController(rootViewController: BrowseViewController())
        let searchViewController = HostingController(rootView: SearchView())
        libraryViewController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical.fill"), tag: 0)
        browseViewController.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "globe"), tag: 1)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        tabController.viewControllers = [libraryViewController, browseViewController, searchViewController]
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = tabController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>){
        if let url = URLContexts.first?.url {
            print("Handling \(url)")
            Task {
                _ = await SourceManager.shared.importSource(from: url)
            }
        }
    }
}
