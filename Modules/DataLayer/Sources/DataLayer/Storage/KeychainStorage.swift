//
//  KeychainStorage.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation
import KeychainAccess
import DomainLayer

/// Centralized app Keychain storage that store data in system keychain.
/// Depends on: [KeychainAccess lib](https://github.com/kishikawakatsumi/KeychainAccess)
public final class KeychainStorage {
    /// Keys for stored values. All keys has application bundle id prefix
    private enum Keys:
        String,
        CodingKey
    {
        case accessToken
        
        private var prefix: String { Bundle.main.bundleIdentifier ?? "KeychainStorage.Keys" }
        var stringValue: String { "\(prefix).\(rawValue)" }
    }
    
    private static let teamID = ""
    
    @KeychainStorage.Value(
        accessGroup: KeychainStorage.teamID,
        key: Keys.accessToken,
        encoder: .basic,
        decoder: .basic
    )
    public var accessToken: String?
}

//MARK: - ClearableStorage
extension KeychainStorage: ClearableStorage {
    public func clear() {
        _accessToken.clear()
    }
}

//MARK: - KeychainStorage.Value
public extension KeychainStorage {
    ///Wrapper around Codable that want to save in Keychain.
    ///In Keychain always store Data object
    @propertyWrapper
    struct Value<
        Element: Codable,
        Key: CodingKey
    >: ClearableStorage {
        //MARK: - Properties
        private let key: Key
        private let keychain: Keychain
        private let decoder: JSONDecoder
        private let encoder: JSONEncoder
        
        public var wrappedValue: Element? {
            get { readAndDecode(for: key) }
            set {
                guard let object = newValue else {
                    try? keychain.remove(key.stringValue)
                    return
                }
                encodeAndSave(object, for: key)
            }
        }
        
        //MARK: - Initialization
        init(
            accessGroup: String,
            key: Key,
            encoder: JSONEncoder,
            decoder: JSONDecoder
        ) {
            let service = Bundle.main.bundleIdentifier ?? "KeychainStorage"
            self.keychain = .init(
                service: service,
                accessGroup: accessGroup
            )
            self.key = key
            self.encoder = encoder
            self.decoder = decoder
        }
        
        //MARK: - Save/Read data
        private func readAndDecode(for key: Key) -> Element? {
            do {
                guard let data = try keychain.getData(key.stringValue) else {
                    return nil
                }
                return try decoder.decode(Element.self, from: data)
            } catch let error {
                fatalError("KeychainStorage.Value of type: \(Element.self) decode error: \(error.localizedDescription)")
            }
        }
    
        private func encodeAndSave(
            _ value: Element,
            for key: Key
        ) {
            do {
                let data = try encoder.encode(value)
                try keychain.set(
                    data,
                    key: key.stringValue
                )
            } catch let error {
                fatalError("KeychainStorage.Value of type: \(Element.self) encode/save error: \(error.localizedDescription)")
            }
        }
        
        //MARK: - ClearableStorage
        public func clear() {
            try? keychain.remove(key.stringValue)
        }
    }
}
