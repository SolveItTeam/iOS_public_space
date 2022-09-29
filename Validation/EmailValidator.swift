//
//  EmailValidator.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

enum EmailValidatorError: Error {
    case empty
    case dontMatchRule
}

struct EmailValidator: Validator {
    typealias Value = String
    
    func validate(_ input: Value) -> ValidatorResult {
        guard !input.isEmpty else {
            return .failure(EmailValidatorError.empty)
        }
        let emailRegex = "[A-Z0-9a-z._-]+@[A-Z0-9a-z._-]+\\.[A-Za-z]{2,4}"
        let regexResult = input.range(of: emailRegex, options: .regularExpression) != nil
        let withoutWhitespaces = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !regexResult || !withoutWhitespaces.isEmpty {
            return .failure(EmailValidatorError.dontMatchRule)
        }
        return .success(())
    }
}
