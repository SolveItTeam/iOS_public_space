//
//  JSONMapper.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

/// Enumerations of JSON mapping operation errors
public enum JSONMapperError: Error {
    case cantDecode(reason: String)
}

/// Plugin that allows to log any mapping error to logging system. Implementation should be provided from main app
public protocol JSONMapperLogPlugin {
    func logError(_ error: JSONMapperError)
}

/// JSON response mapper that works with Decodable objects
protocol JSONMapper {
    func set(decoder: JSONDecoder)
    func connect(_ logPlugin: JSONMapperLogPlugin)
    func map<T: Decodable>(
        _ data: Data,
        to: T.Type
    ) throws -> T
}

final class JSONMapperImpl: JSONMapper {
    //MARK: - Propeties
    private var decoder: JSONDecoder?
    private var logPlugin: JSONMapperLogPlugin?
    
    //MARK: - JSONMapper
    func set(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func connect(_ logPlugin: JSONMapperLogPlugin) {
        self.logPlugin = logPlugin
    }
    
    func map<T>(
        _ data: Data,
        to: T.Type
    ) throws -> T where T : Decodable {
        do {
            guard let jsonDecoder = decoder else {
                fatalError("JSONMapperImpl. don't have JSONDecoder instance")
            }
            let result = try jsonDecoder.decode(to, from: data)
            return result
        } catch let error {
            let publicError = JSONMapperError.cantDecode(reason: error.localizedDescription)
            logPlugin?.logError(publicError)
            throw publicError
        }
    }
}
