//
//  AppSystemEnvironment.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Combine
import Foundation
import Extensions

/// Centralized point to get an access to system events and DI container
final class AppSystemEnvironment {
    static let events = SystemEventsHandler()
    static let di = DIContainer()

    private init(){}
}

/// Centralized point to get an access to system events:
/// - Keyboard appearing/dissapearing
/// - Scene lifecycle
final class SystemEventsHandler {
    let keyboardEventPublisher: KeyboardEventPublisher
    let sceneLifecycleEventPublisher: SceneLifecyclePublisher
    
    init(notificationCenter: NotificationCenter = .default) {
        keyboardEventPublisher = notificationCenter.keyboardEventPublisher
        sceneLifecycleEventPublisher = notificationCenter.sceneLifecycleEventPublisher
    }
}
