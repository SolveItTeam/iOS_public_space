import DomainLayer

/// Entry point to an application Data layer
public struct DataLayer {
    
}

public extension DataLayer {
    
    /// Factory that produces an instances of all repositories
    struct RepositoriesFactory {
        public init() {}
        
        public func makeExampleRepository() -> ExampleRepository {
            ExampleRepositoryImpl()
        }
        
        public func makeSettings() -> SharedStorage {
            SharedStorageImpl()
        }
    }
}
