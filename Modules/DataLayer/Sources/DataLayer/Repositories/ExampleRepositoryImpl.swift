//
//  ExampleRepositoryImpl.swift
//

import Foundation
import DomainLayer

/// Provides an implementation of ExampleRepository from DomainLayer.
/// In real project inside implementation you can perform network call, read from local file and etc.
final class ExampleRepositoryImpl {
    
}

extension ExampleRepositoryImpl: ExampleRepository {
    func getSomeData() async -> ExampleEntity {
        ExampleModel(text: "Hello").toDomainEntity()
    }
}


struct ExampleModel {
    let text: String
}

extension ExampleModel: DomainEntityConvertable {
    typealias DomainEntity = ExampleEntity
    
    func toDomainEntity() -> ExampleEntity {
        .init(text: self.text)
    }
}
