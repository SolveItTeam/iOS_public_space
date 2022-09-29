//
//  DateConverter.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

///An object that converts String date representation to Date object and Date to String representation
public final class DateFormatUseCase {
    public enum Format: String {
        case yyyyMMddT = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMMdd = "yyyy-MM-dd"
        case MMMM = "MMMM"
        case ddMMyyyy = "dd.MM.yyyy"
        case dd = "dd"
    }
    
    private let formatter: DateFormatter
    
    //MARK: - Initialization
    public init() {
        formatter = DateFormatter()
        formatter.timeZone = .current
    }
    
    //MARK: - Formatting
    private func apply(_ format: Format, to string: String) -> Date? {
        formatter.dateFormat = format.rawValue
        return formatter.date(from: string)
    }
    
    public func toDateWithddMMyyyy(_ input: String) -> Date? {
        apply(.ddMMyyyy, to: input)
    }
}
