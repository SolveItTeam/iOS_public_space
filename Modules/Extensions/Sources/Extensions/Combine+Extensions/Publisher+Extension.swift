//
//  Publisher+Extension.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.

import Combine
import Foundation

public extension Publisher {
    /// Allows to use only _sink_ method to handle value and error in one place
    /// - How to use:
    /// ```
    /// storage
    ///     .fetchAll(
    ///        TestModel.self,
    ///        predicate: nil,
    ///        sortDescriptors: nil
    ///      )
    ///     .toResult()
    ///     .sink { result in
    ///         switch result {
    ///         case .failure(let error):
    ///             print(error)
    ///         case .success(let items):
    ///             print(items)
    ///         }
    ///     }
    ///     .store(in: &subs)
    ///```
    func toResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch({ Just(.failure($0)) })
            .eraseToAnyPublisher()
    }
}
