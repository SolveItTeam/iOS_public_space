//
//  NotificationCenter+Extensions.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Combine

/// An object that handle all Combine subscriptions. Similar as DisposeBag in RxSwift
public final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    @resultBuilder
    public struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
    
    //MARK: - Initialization
    public init() {}
    
    deinit {
        cancel()
    }
    
    //MARK: - Methods
    public func cancel() {
        subscriptions.removeAll()
    }
    
    public func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }
}

//MARK: - AnyCancellable
public extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
