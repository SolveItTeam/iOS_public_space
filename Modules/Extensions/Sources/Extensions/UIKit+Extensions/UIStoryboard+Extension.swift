//
//  UIStoryboard+Extension.swift
//
//  Created by SOLVEIT on 25.08.2020.
//  Copyright © 2020 SOLVEIT. All rights reserved.
//

import UIKit

// swiftlint:disable force_cast
public extension UIStoryboard {
    /// Load ViewController from storyboard by identifier. ViewController identifier should be similar to class name
    /// - How to use:
    /// ```
    /// UIStoryboard.live.load(NotificationsViewController.self)
    /// ```
    func load<T: UIViewController>(_ type: T.Type) -> T {
        let idenitifer = String(describing: T.self)
        return instantiateViewController(withIdentifier: idenitifer) as! T
    }
}
// swiftlint:enable force_cast

