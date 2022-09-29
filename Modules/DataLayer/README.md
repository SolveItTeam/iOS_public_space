# DataLayer

Implementation of a data layer.

To see documetations for source code — build project `.docc` document

## Should contains
- API calls implementations. And all network related classes
- Repositories implementations
- CoreData storage implementation
- Shared storage (UserDefaults and Keychain) implementation

## Structure
- Extensions
    - CodableCoders+Extensions — shared JSONEncoder/JSONDecoder
- Storage
    - DefaultsStorage — UserDefault storage
    - KeychainStorage — Keychain storage
- Repositories
    - SharedStorageImpl — implementation of `SharedStorage`

## Guides
- Access to Data layer should provide via `DataLayer.swift`
- All models that represents data layer should have `Model` prefix
- Classes with `Model` prefix can't leave outside from `Data` layer
- For convertation from `Model` object to `Entity` — subscribe `Model` class to a `DomainEntityConvertable` protocol
- For a network stack implementation use [Alamofire](https://github.com/Alamofire/Alamofire)
