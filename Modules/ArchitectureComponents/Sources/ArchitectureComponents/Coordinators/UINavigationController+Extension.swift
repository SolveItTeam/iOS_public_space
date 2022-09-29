//
//  UINavigationController+Extension.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

extension UINavigationController {
    func getIndex(of viewController: AnyClass) -> Int? {
        return viewControllers.firstIndex(where: { $0.isKind(of: viewController) })
    }

    func hideBackTextAndPush(controller: UIViewController, animated: Bool) {
        let emptyItem = makeEmptyBackItem()
        topViewController?.navigationItem.backBarButtonItem = emptyItem
        controller.navigationItem.backBarButtonItem = emptyItem
        pushViewController(controller, animated: animated)
    }

    func hideBackTextAndSet(controllers: [UIViewController], animated: Bool) {
        let emptyItem = makeEmptyBackItem()
        topViewController?.navigationItem.backBarButtonItem = emptyItem
        controllers.forEach {
            $0.navigationItem.backBarButtonItem = emptyItem
        }
        setViewControllers(controllers, animated: animated)
    }

    private func makeEmptyBackItem() -> BackBarButtonItem {
        return BackBarButtonItem(
            title: " ",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
