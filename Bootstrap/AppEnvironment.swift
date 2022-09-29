//
//  AppEnvironment.swit
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

/// An entry point to get an access to environment variables from `.xcconfig` files
enum AppEnvironment {
    private enum Keys: String {
        case serverPath = "SERVER_PATH"
        case isEnabledDebugWindow = "IS_ENABLED_DEBUG_WINDOW"
        case isEnabledLogs = "IS_ENABLED_LOGS"
        case shouldSendAnaylytics = "IS_SEND_ANALYTICS"
        case shouldShowSchemeName = "SHOULD_SHOW_SCHEME_NAME"
        case schemeName = "SCHEME_NAME"
    }
    
    //MARK: - Public
    /// Base server path to backend
    static let serverPath: URL = {
        guard let path = getUrlString(for: .serverPath),
              let pathURL = URL(string: path) else {
            fatalError("Environment. incorrect server path")
        }
        return pathURL
    }()
    
    /// Flag to manage QA menu in builds
    static let isEnabledDebugWindow: Bool = {
        return boolValue(for: .isEnabledDebugWindow)
    }()
    
    /// Flag to manage turn on/off loggin in application
    static let isEnabledLogs: Bool = {
        return boolValue(for: .isEnabledLogs)
    }()
    
    /// Flag to manage turn on/off send app analytics to services
    static let shouldSendAnaylytics: Bool = {
        return boolValue(for: .shouldSendAnaylytics)
    }()
    
    /// Flag to manage turn on/off display current scheme name on Splash screen
    static let shouldShowSchemeName: Bool = {
       return boolValue(for: .shouldShowSchemeName)
    }()
    
    static let schemeName: String = {
        guard let value = plist[Keys.schemeName.rawValue] as? String else {
            fatalError("Environment. incorrect string representation for \(Keys.schemeName.rawValue)")
        }
        return value
    }()
}

// MARK: - Private
private extension AppEnvironment {
    private static let plist: JSON = {
        return Bundle.main.infoDictionary ?? JSON()
    }()
    
    private static func boolValue(for key: Keys) -> Bool {
        guard let stringValue = plist[key.rawValue] as? String else {
            fatalError("Environment. incorrect bool representation for \(key.rawValue)")
        }
        return stringValue == "YES"
    }
    
    private static func getUrlString(for key: Keys) -> String? {
        return (plist[key.rawValue] as? String)?.replacingOccurrences(of: "\\", with: "")
    }
}
