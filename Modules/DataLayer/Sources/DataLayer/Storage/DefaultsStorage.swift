//
//  DefaultsStorage.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation
import DomainLayer

/// Centralized app settings storage that store data in UserDefaults.
/// Depends on: [CodableCoders+Extensions](https://github.com/SolveItTeam/iOS_shared_code/blob/master/Foundation%2BExtensions/CodableCoders%2BExtensions.swift)
public final class DefaultsStorage {
    /// Keys for stored values. All keys has an application bundle id prefix
    private enum Keys:
        String,
        CodingKey
    {
        case isLogin
        
        private var prefix: String { Bundle.main.bundleIdentifier ?? "DefaultsStorage.Keys" }
        var stringValue: String { "\(prefix).\(rawValue)" }
    }
    
    //MARK: - Values
    @DefaultsStorage.ValueWrapper(
        key: Keys.isLogin,
        defaultValue: false,
        storage: .standard,
        encoder: .basic,
        decoder: .basic
    )
    public var isLogin: Bool
}

//MARK: - ClearableStorage
extension DefaultsStorage: ClearableStorage {
    public func clear() {
        _isLogin.clear()
    }
}

//MARK: - DefaultsStorage.ValueWrapper
extension DefaultsStorage {
    /// Wrapper around Codable that want to save in UserDefaults.
    /// When to decode/encode Date objects will apply millisecondsSince1970 strategy
    @propertyWrapper
    public struct ValueWrapper<Element: Codable>: ClearableStorage {
        let key: CodingKey
        let defaultValue: Element
        let storage: UserDefaults
        let encoder: JSONEncoder
        let decoder: JSONDecoder
        
        /// Access to wrapper value
        public var wrappedValue: Element {
            get { read(for: key) ?? defaultValue }
            set {
                if let value = newValue as? AnyOptional, value.isNil {
                    clear()
                } else {
                    save(object: newValue, key: key)
                }
            }
        }
        
        private func save(
            object: Element,
            key: CodingKey
        ) {
            do {
                let data = try encoder.encode(object)
                storage.setValue(data, forKey: key.stringValue)
            } catch let error {
                fatalError("DefaultsStorage.ValueWrapper. error \(error.localizedDescription) to encode value of type: \(Element.self)")
            }
        }
        
        private func read(for key: CodingKey) -> Element? {
            do {
                guard let data = storage.value(forKey: key.stringValue) as? Data else {
                    return nil
                }
                let object = try decoder.decode(
                    Element.self,
                    from: data
                )
                return object
            } catch let error {
                fatalError("DefaultsStorage.ValueWrapper. error \(error.localizedDescription) to decode value of type: \(Element.self)")
            }
        }
        
        //MARK: - ClearableStorage
        /// Remove value from UserDefaults
        public func clear() {
            storage.removeObject(forKey: key.stringValue)
        }
    }
}

//MARK: - Internal convenience protocol
private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool {
        return self == nil
    }
}
