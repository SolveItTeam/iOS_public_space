//
//  DIContainer.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation
import Resolver
import DataLayer
import DomainLayer
import Extensions

final class DIContainer {
    private let container: Resolver
    
    init() {
        container = .main
        register()
    }
    
    func resolve<T>() -> T {
        container.resolve()
    }
    
    private func register() {
        container.register {
            PushNotificationsServiceImpl()
        }
        .implements(PushNotificationsTokenRepository.self)
        .implements(IncomingPushNotificationsService.self)
        .implements(PushNotificationsService.self)
        .scope(.application)
        
        container.register { resolver, args in
            DomainLayer.UseCasesFactory().makeUserSession(
                repository: resolver.resolve(),
                settings: DataLayer.RepositoriesFactory().makeSettings()
            )
        }
        .scope(.application)
        
        container.register {
            DateFormatUseCase()
        }
        .scope(.application)
        
        container.register {
            AmountFormatUseCase()
        }
        .scope(.application)
    }
}

