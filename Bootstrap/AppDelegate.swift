//
//  AppDelegate.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//


import UIKit
import Resolver
import Logger

@main
final class AppDelegate:
    UIResponder,
    UIApplicationDelegate
{
    var window: UIWindow?
    var services = [UIApplicationDelegate]()
    @Injected
    private var logger: AppLog
    
    //MARK: - UIApplicationDelegate Lifecycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let pushService: PushNotificationsService = AppSystemEnvironment.di.resolve()
        services.append(pushService)
        
        logger.setMode(AppSystemEnvironment.appLogMode)
        let appWindow = UIWindow(frame: UIScreen.main.bounds)
        let debugHandler: AppDebugConsolePlugin = .init(appWindow: appWindow)
        services.append(debugHandler)
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        services.forEach({ $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        services.forEach({ $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) })
    }

    //MARK: - UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}

