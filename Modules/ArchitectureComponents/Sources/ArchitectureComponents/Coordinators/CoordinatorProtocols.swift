//
//  CoordinatorProtocols.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

/// Basic interface for Coordinator implementation
public protocol Coordinatable: AnyObject {
    func start()
    func add(_ child: Coordinatable)
    func remove(_ child: Coordinatable)
}

/// Defines callback for user flow that can finish.
/// Example: user successfully create new order and after that we need to return user to main screen.
public protocol FinishFlowSupportable {
    var onFinish: (() -> Void)? { get set }
}

/// Defines callback for user flow that can close.
/// Example: user open "Create new order" flow and click back button.
/// We need to remove coordinator that associated with given user story from coordinators hierarchy.
public protocol CloseFlowSupportable {
    var onClose: (() -> Void)? { get set }
}

public protocol Presentable: AnyObject {
    var toPresent: UIViewController? { get }
}

extension UIViewController: Presentable {
    public var toPresent: UIViewController? { return self }
}
