import Foundation

public typealias SharedStorage = TokenRepository & SettingsStorage

public protocol TokenRepository: ClearableStorage {
    var accessToken: String? { get set }
}

public protocol SettingsStorage: ClearableStorage {
    var isLogin: Bool { get set }
}
