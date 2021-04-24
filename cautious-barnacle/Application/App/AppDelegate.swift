//
//  AppDelegate.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 16.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        runUI()
        
        return true
    }
    
    private func runUI() {
        self.window = UIWindow()
        
        let navigationVC = UINavigationController()
        navigationVC.navigationBar.prefersLargeTitles = true
        let router = RouterImp(rootController: navigationVC)
        let screenFactory = ScreenFactoryImp()
        let coordinator = AppCoordinator(router: router, screenFactory: screenFactory)
        coordinator.start()
        
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
    }
}


