//
//  AmountFormatter.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.

import Foundation

/// An object that format an amount values.
/// **Example**: 1000 will format to 1 000
public final class AmountFormatUseCase {
    private let formatter: NumberFormatter
    
    public init() {
        formatter = .init()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
    }
    
    public func format(_ value: Decimal) -> String {
        formatter.string(from: value as NSNumber) ?? ""
    }
    
    public func round(_ price: Double) -> Int {
        price.roundNearestInt()
    }
}

private extension Double {
    func roundNearestInt() -> Int {
        let rounded = self.rounded(.toNearestOrAwayFromZero)
        return Int(rounded)
    }
}
