//
//  ExampleRepository.swift
//

import Foundation

/// Interface for an example repository -> see Data layer for implementation
public protocol ExampleRepository {
    func getSomeData() async -> ExampleEntity
}

