//
//  BaseCoordinator.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

open class BaseCoordinator: Coordinatable {
    public var childrens: [Coordinatable]

    public init() {
        childrens = [Coordinatable]()
    }

    deinit {
        childrens.removeAll()
    }

    open func start() {

    }

    //MARK: - Manage dependencies
    public func add(_ child: Coordinatable) {
        for element in childrens where  child === element {
            return
        }
        childrens.append(child)
    }

    public func remove(_ child: Coordinatable) {
        guard !childrens.isEmpty else { return }
        for (index, element) in childrens.enumerated() where element === child {

            childrens.remove(at: index)
            break
        }
    }
}
