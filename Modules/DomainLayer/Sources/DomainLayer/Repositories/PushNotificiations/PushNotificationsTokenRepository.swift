//
//  PushNotificationsTokenRepository.swift
//  
//

import Foundation

/// Enumeration of all push notification servier errors
public enum PushNotificationServiceError: Error {
    case cantRegisterForPushNotification
    case cantDecodeNotification
}

/// Enumeration of registration process events
public enum PushNotificationRegistrationEvent {
    case deniedAccess
    case registered(token: String)
}

/// Provides an access to device push notification token
public protocol PushNotificationsTokenRepository {
    /// Register device for push notifications
    func register() async throws -> PushNotificationRegistrationEvent
    
    /// Unregister device from push notifications
    func unregister()
}
