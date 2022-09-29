//
//  ExampleUseCase.swift
//

import Foundation

/// Defines a public interface for business logic example use case
public protocol ExampleUseCase {
    func execute() async -> ExampleEntity
}

/// An actual implementation of business logic use case
final class ExampleUseCaseImpl {
    private let repository: ExampleRepository
    
    init(repository: ExampleRepository) {
        self.repository = repository
    }
}

//MARK: - ExampleUseCase
extension ExampleUseCaseImpl: ExampleUseCase {
    func execute() async -> ExampleEntity {
        await repository.getSomeData()
    }
}

