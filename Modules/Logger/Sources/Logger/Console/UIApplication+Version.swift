import UIKit

//
//  UIApplication+Version.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

extension UIApplication {
    /// Return application version (short version + bundle version) in format "appVersion.buildVersion"
    var version: String {
        let appVersion = infoValue(for: "CFBundleShortVersionString")
        let buildVersion = infoValue(for: "CFBundleVersion")
        return appVersion + "." + buildVersion
    }
    
    private func infoValue(for key: String) -> String {
        let value = Bundle.main.infoDictionary?[key] as? String
        return value ?? ""
    }
}
