//
//  Validator.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

/// Type for validator operation result
typealias ValidatorResult = Swift.Result<Void, Error>

/// Contract for all input validators
protocol Validator {
    associatedtype Value
    func validate(_ input: Value) -> ValidatorResult
}

/// Contract for all input validators that have maximum length constraint
protocol LimitedValidator: Validator {
    static var maxLength: Int { get }
}
