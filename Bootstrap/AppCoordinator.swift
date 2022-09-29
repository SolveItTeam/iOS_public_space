//
//  AppCoordinator.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//


import UIKit

/// Main coordinator of application
final class AppCoordinator: BaseCoordinator {
    //MARK: - Properties
    private weak var window: UIWindow?
    private let sessionResponder: UserSessionResponder
    private let cancelBag: CancelBag
    
    //MARK: - Initialization
    init(
        window: UIWindow,
        sessionResponder: UserSessionResponder
    ) {
        self.window = window
        self.sessionResponder = sessionResponder
        self.cancelBag = .init()
        super.init()
    }
    
    //MARK: - Lifecycle
    override func start() {
        sessionResponder.start { [weak self] publisher in
            guard let self = self else { return }
            publisher.sink { instruction in
                self.childrens.removeAll()
                
                switch instruction {
                case .authorized:
                    self.openAuthorized()
                case .auth:
                    self.openAuth()
                }
                self.window?.makeKeyAndVisible()
            }
            .store(in: self.cancelBag)
        }
    }

    private func openAuth() {
        let object = CoordinatorFactory().makeAuth()
        add(object.coordinator)
        object.coordinator.start()
        window?.rootViewController = object.router.root
    }
    
    private func openAuthorized() {
        let object = CoordinatorFactory().makeAuthorized()
        add(object.coordinator)
        object.coordinator.start()
        window?.rootViewController = object.router.root
    }
}
