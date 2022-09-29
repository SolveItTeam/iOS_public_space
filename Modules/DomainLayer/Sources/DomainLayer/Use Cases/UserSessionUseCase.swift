//
//  UserSessionUseCase.swift
//  
//
//  Created by andrey on 17.02.22.
//

import Foundation
import Combine

/// Enumeration of possible app launch variants. Also calculate current lauch instruction based on system internal flags
public enum AppLaunchInstructor {
    case auth
    case authorized
    
    static func instruct(isLogined: Bool) -> Self {
        switch isLogined {
        case true:
            return .authorized
        case false:
            return .auth
        }
    }
}

/// Represents current user application session.
/// All operations that are influencing to user state in app should be performed in this class
public protocol UserSessionUseCase {
    /// Mutator/Accessor for API token
    var accessToken: String? { get set }
    
    /// Start current user session. Should call this method on app launch and subscribe to AppLaunchInstructor publisher
    func start(instruct: @escaping (_ publisher: AnyPublisher<AppLaunchInstructor, Never>) -> Void)
    
    /// Set current user as authorized in application and push new AppLaunchInstructor
    func authorized()
    
    /// Close current user session:
    /// - clear keychain, defaults
    /// - unregister from push notifications
    /// - push new AppLaunchInstructor
    func close()
    
    /// Start push notification registration process:
    /// - ask permission
    /// - process APNS token
    /// - return a PushNotificationRegistrationEvent (token or denied access)
    func requestPushNotificationToken() async throws -> PushNotificationRegistrationEvent
}

final class UserSessionUseCaseImpl {
    //MARK: - Properties
    private let pushTokenRepository: PushNotificationsTokenRepository
    private var settingsStorage: SharedStorage
    private let appLaunchInstructionSubject: PassthroughSubject<AppLaunchInstructor, Never>
    
    //MARK: - Initialization
    init(
        pushTokenRepository: PushNotificationsTokenRepository,
        settingsStorage: SharedStorage
    ) {
        self.pushTokenRepository = pushTokenRepository
        self.settingsStorage = settingsStorage
        self.appLaunchInstructionSubject = .init()
    }
    
    private func publishLaunchInstruction() {
        let instruction = AppLaunchInstructor.instruct(isLogined: settingsStorage.isLogin)
        appLaunchInstructionSubject.send(instruction)
    }
}

//MARK: - UserSessionResponder
extension UserSessionUseCaseImpl: UserSessionUseCase {
    var accessToken: String? {
        get { settingsStorage.accessToken }
        set { settingsStorage.accessToken = newValue }
    }
    
    func start(instruct: @escaping (_ publisher: AnyPublisher<AppLaunchInstructor, Never>) -> Void) {
        if !settingsStorage.isLogin {
            settingsStorage.clear()
        }
        instruct(appLaunchInstructionSubject.eraseToAnyPublisher())
        publishLaunchInstruction()
    }
    
    func authorized() {
        settingsStorage.isLogin = true
        publishLaunchInstruction()
    }
    
    func close() {
        pushTokenRepository.unregister()
        settingsStorage.clear()
        publishLaunchInstruction()
    }
    
    func requestPushNotificationToken() async throws -> PushNotificationRegistrationEvent {
        try await pushTokenRepository.register()
    }
}

