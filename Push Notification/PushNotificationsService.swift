//
//  PushNotificationService.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit
import Combine
import UserNotifications
import FirebaseMessaging
import DomainLayer

/// An object that incapsulates logic for:
/// - Register/unregister application for push notifications
/// - Exchange APNS token to Firebase token
/// - Increment/decrement app icon badge base on application lifecycle
/// - Process incoming push notification payload and convert it to `PushNotification` model

/// In project your main coordinator for authorized zone should subscribe to `IncomingPushNotificationsPublisher` and handle all incoming `IncomingPushNotificationPublisherEvent`
/// to handle all incoming notifications

//MARK: - Types
typealias IncomingPushNotificationsPublisher = AnyPublisher<IncomingPushNotificationPublisherEvent, Never>
typealias IncomingPushNotificationPublisherEvent = Swift.Result<PushNotification, PushNotificationServiceError>
typealias PushNotificationsService = PushNotificationsTokenRepository & IncomingPushNotificationsService & UIApplicationDelegate

/// An interface to subscribe incoming push notification sequence
protocol IncomingPushNotificationsService {
    var incomingNotificationsPublisher: IncomingPushNotificationsPublisher { get }
}

//MARK: - Implementation
final class PushNotificationsServiceImpl:
    NSObject,
    IncomingPushNotificationsService
{
    //MARK: - Properties
    private let userNotificationCenter: UNUserNotificationCenter
    private let application: UIApplication
    
    private var deviceTokenHandler: ((_ result: Result<String, PushNotificationServiceError>) -> Void)?
    private let notificationsSubject: PassthroughSubject<IncomingPushNotificationPublisherEvent, Never>
    
    var incomingNotificationsPublisher: IncomingPushNotificationsPublisher
    
    //MARK: - Initialization
    init(
        userNotificationCenter: UNUserNotificationCenter = .current(),
        application: UIApplication = .shared
    ) {
        self.userNotificationCenter = userNotificationCenter
        self.application = application
        self.notificationsSubject = .init()
        self.incomingNotificationsPublisher = notificationsSubject.eraseToAnyPublisher()
        super.init()
    }
}

//MARK: - UIApplicationDelegate
extension PushNotificationsServiceImpl: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        userNotificationCenter.delegate = self
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { [weak self] token, error in
            if error != nil {
                //TODO: log error
                self?.deviceTokenHandler?(.failure(.cantRegisterForPushNotification))
            } else if let token = token {
                //TODO: log success
                self?.deviceTokenHandler?(.success(token))
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        deviceTokenHandler?(.failure(.cantRegisterForPushNotification))
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension PushNotificationsServiceImpl: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        defer {
            completionHandler()
        }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let content = response.notification.request.content
        handle(notificationContent: content)
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.sound, .badge])
        handle(notificationContent: notification.request.content)
    }
    
    private func handle(notificationContent: UNNotificationContent) {
        guard let notification = PushNotification(payload: notificationContent.userInfo) else {
            notificationsSubject.send(.failure(.cantDecodeNotification))
            return
        }
        //TODO: Better will be to receive a `applicationIconBadgeNumber` value from server
        application.applicationIconBadgeNumber += 1
        notificationsSubject.send(.success(notification))
    }
}

//MARK: - PushNotificationsTokenRepository
extension PushNotificationsServiceImpl: PushNotificationsTokenRepository {
    func register() async throws -> PushNotificationRegistrationEvent {
        let event: PushNotificationRegistrationEvent = try await withCheckedThrowingContinuation({ [weak self] continuation in
            guard let self = self else { return }
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            self.userNotificationCenter.requestAuthorization(options: options) { isGranted, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        continuation.resume(throwing: PushNotificationServiceError.cantRegisterForPushNotification)
                        return
                    }
                    if isGranted {
                        self.deviceTokenHandler = { result in
                            switch result {
                            case .success(let token):
                                continuation.resume(returning: .registered(token: token))
                            case .failure(let error):
                                continuation.resume(throwing: error)
                            }
                            self.deviceTokenHandler = nil
                        }
                        self.application.registerForRemoteNotifications()
                    } else {
                        continuation.resume(returning: .deniedAccess)
                    }
                }
            }
        })
        return event
    }
    
    func unregister() {
        application.applicationIconBadgeNumber = 0
        application.unregisterForRemoteNotifications()
        Messaging.messaging().deleteToken { error in
            if error != nil {
                //log error to logger mechanism
            } else {
               //log success unregister
            }
        }
    }
}

