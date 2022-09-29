//
//  CodableCoders+Extensions.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

extension JSONEncoder {
    /// Predefined encoder
    /// - dateEncodingStrategy is .millisecondsSince1970
    /// - outputFormatting is .prettyPrinted
    static var basic: JSONEncoder {
        let object = JSONEncoder()
        object.dateEncodingStrategy = .millisecondsSince1970
        object.outputFormatting = .prettyPrinted
        return object
    }
}

extension JSONDecoder {
    /// Predefined decoder
    /// - dateDecodingStrategy is .millisecondsSince1970
    static var basic: JSONDecoder {
        let object = JSONDecoder()
        object.dateDecodingStrategy = .millisecondsSince1970
        return object
    }
}
