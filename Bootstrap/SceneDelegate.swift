//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//
//  SceneDelegate.swift
//

import UIKit

final class SceneDelegate:
    UIResponder,
    UIWindowSceneDelegate
{
    //MARK: — Properties
    var window: UIWindow? {
        didSet {
            appDelegate.window = window
        }
    }
    private var appDelegate: AppDelegate {
        guard let object = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can't get an access to AppDelegate")
        }
        return object
    }
    
    private var coordinator: Coordinatable!

    //MARK: — UIWindowSceneDelegate
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        let windowObject = UIWindow(windowScene: windowScene)
        window = windowObject
        
        coordinator = CoordinatorFactory().makeApp(window: windowObject)
        coordinator.start()
    }
}

