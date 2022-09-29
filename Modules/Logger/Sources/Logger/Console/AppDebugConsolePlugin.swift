//
//  AppDebugHandler.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit
import PulseUI

/// Application plugin that add QA console functionality to the app. `Notes`: To open debug menu: tap with two fingers on screen
/// `How to use`:
/// - Open AppDelegate.swift
/// - In `application(_ application: UIApplication, didFinishLaunchingWithOptions...)` method read value from `AppEnvironment.isEnabledDebugWindow`
/// - If value equals `true` - create an object of  `AppDebugConsolePlugin` with UIWindow object from `AppDelegate` and store object in `AppDebugConsolePlugin`
public final class AppDebugConsolePlugin: NSObject {
    private let baseServerPath: String
    private weak var appWindow: UIWindow?
    private var debugWindow: UIWindow?
    
    //MARK: - Initialization
    public init(
        appWindow: UIWindow,
        baseServerPath: String
    ) {
        self.baseServerPath = baseServerPath
        self.appWindow = appWindow
        super.init()
    }
    
    //MARK: - Actions
    @objc private func tapRecognized() {
        let viewController = AppDebugController(
            delegate: self,
            baseServerPath: baseServerPath
        )
        
        let navigationController = UINavigationController(rootViewController: viewController)
        debugWindow?.rootViewController = navigationController
        debugWindow?.makeKeyAndVisible()
        debugWindow?.alpha = 1
    }
}

//MARK: - AppDebugControllerDelegate
extension AppDebugConsolePlugin: AppDebugControllerDelegate {
    func appDebugControllerDidPressClose() {
        debugWindow?.rootViewController = nil
        debugWindow?.resignKey()
        debugWindow?.alpha = 0
        appWindow?.makeKeyAndVisible()
    }
    
    func appDebugControllerDidSelect(_ option: AppDebugOption) {
        switch option {
        case .console:
            let console = MainViewController {
                self.tapRecognized()
            }
            debugWindow?.rootViewController = console
        }
    }
}

//MARK: - UIApplicationDelegate
extension AppDebugConsolePlugin: UIApplicationDelegate {
    @discardableResult
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        debugWindow = .init(frame: UIScreen.main.bounds)
        debugWindow?.backgroundColor = .clear
        debugWindow?.windowLevel = .alert
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        tapRecognizer.numberOfTouchesRequired = 2
        appWindow?.addGestureRecognizer(tapRecognizer)
        
        return true
    }
}
