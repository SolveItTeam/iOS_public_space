/// Entry point for Domain layer
public enum DomainLayer {
    
}

//MARK: - Use cases factory
public extension DomainLayer {
    /// Factory that produces an instances of all use cases
    struct UseCasesFactory {
        public init(){}
        
        public func makeExample(repository: ExampleRepository) -> ExampleUseCase {
            ExampleUseCaseImpl(repository: repository)
        }
    
        public func makeUserSession(
            repository: PushNotificationsTokenRepository,
            settings: SharedStorage
        ) -> UserSessionUseCase {
            UserSessionUseCaseImpl(
                pushTokenRepository: repository,
                settingsStorage: settings
            )
        }
    }
}
