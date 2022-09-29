//
//  JailbreakDetector.swift
//  SolveIT
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

public final class JailbreakDetector {
    public var isJailbroken: Bool {
        #if targetEnvironment(simulator)
            return false
        #else
        guard let cydiaUrlScheme = URL(string: "cydia://package/com.example.package") else {
            return inspectIsJailbroken()
        }
        
        let application = UIApplication.shared
        return application.canOpenURL(cydiaUrlScheme) || inspectIsJailbroken()
        #endif
    }
    
    //MARK - Initialization
    public init() {}
    
    //MARK - Methods
    private func inspectIsJailbroken() -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/usr/bin/ssh") {
            return true
        }
        
        if canOpen("/Applications/Cydia.app") ||
            canOpen("/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen("/bin/bash") ||
            canOpen("/usr/sbin/sshd") ||
            canOpen("/etc/apt") ||
            canOpen("/usr/bin/ssh") {
            return true
        }
        
        let path = "/private/" + UUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    private func canOpen(_ path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else {
            return false
        }
        fclose(file)
        return true
    }
}
