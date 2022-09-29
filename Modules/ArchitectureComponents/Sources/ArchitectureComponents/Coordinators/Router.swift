//
//  Router.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

public final class Router {
    public var topViewController: UIViewController? {
        return rootController?.topViewController
    }

    public var root: UINavigationController? {
        return rootController
    }

    fileprivate var rootController: UINavigationController?

    //MARK: - Initialization
    public required init(rootController: UINavigationController = .init()) {
        self.rootController = rootController
    }

    //MARK: - Routing
    public func present(_ module: UIViewController, animated: Bool) {
        rootController?.present(module,
                                animated: animated,
                                completion: nil)
    }

    public func push(_ module: UIViewController, animated: Bool) {
        guard
            !(module is UINavigationController)
        else { assertionFailure("⚠️Deprecated push UINavigationController."); return }
        rootController?.hideBackTextAndPush(controller: module, animated: animated)
    }

    public func popModule(animated: Bool) {
        rootController?.popViewController(animated: animated)
    }

    public func popTo(controllerIndex: Int, animated: Bool) {
        guard let root = rootController else { return }
        let destination = root.viewControllers[controllerIndex]
        rootController?.popToViewController(destination,
                                            animated: animated)
    }

    public func dismissModule(animated: Bool) {
        rootController?.dismiss(animated: animated, completion: nil)
    }
    
    public func disableNavigationSlide() {
        rootController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public func setRootModule(
        _ module: UIViewController,
        hideBar: Bool = false,
        animated: Bool = false
    ) {
        rootController?.setViewControllers([module], animated: animated)
        rootController?.isNavigationBarHidden = hideBar
    }

    public func popToRootModule(animated: Bool) {
        rootController?.popToRootViewController(animated: animated)
    }

    public func select(tab withIndex: Int) {
        rootController?.tabBarController?.selectedIndex = withIndex
    }
    
    public func hideTabBar(hideTabBar: Bool) {
        rootController?.tabBarController?.tabBar.isHidden = hideTabBar
    }

    public func set(controllers: [UIViewController]) {
        rootController?.setViewControllers(controllers, animated: false)
    }

    public func add(controllers: [UIViewController]) {
        var currentStack = rootController?.viewControllers ?? []
        currentStack.append(contentsOf: controllers)
        rootController?.hideBackTextAndSet(controllers: currentStack, animated: false)
    }

    public func pop(to viewController: AnyClass, animated: Bool) {
        guard let index = root?.getIndex(of: viewController) else { return }
        popTo(controllerIndex: index, animated: animated)
    }
}
