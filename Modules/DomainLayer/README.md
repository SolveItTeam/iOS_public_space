# DomainLayer

Implementation of a domain layer.
To see documetations for source code — build project `.docc` document

## Should contains
- Repositories protocols
- Enteties
- UseCase's implementation

## Structure
- Repositories
    - TokenRepository — storage for API tokens
    - SettingsStorage — storage for user settings
    - PushNotificationsTokenRepository - provide APNS token
- Use cases
    - AmountFormatUseCase — format different amounts
    - DateFormatUseCase — format string to date or date to string
    - UserSessionUseCase — manage all details about user session


## Notes
> In Domain layer we have wrappers for UserDefaults and Keychain storages. We know that it breaks an agreements for a layered architecture, but we do this to have all benefits from a property wrappers functionality
