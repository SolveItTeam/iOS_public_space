import DomainLayer

final class SharedStorageImpl {
    private var defaults: DefaultsStorage
    private var keychain: KeychainStorage
    
    init(
        defaults: DefaultsStorage = .init(),
        keychain: KeychainStorage = .init()
    ) {
        self.defaults = defaults
        self.keychain = keychain
    }
}

//MARK: - ClearableStorage
extension SharedStorageImpl: ClearableStorage {
    func clear() {
        defaults.clear()
        keychain.clear()
    }
}

//MARK: - TokenRepository
extension SharedStorageImpl: TokenRepository {
    var accessToken: String? {
        get { keychain.accessToken }
        set { keychain.accessToken = newValue }
    }
}

//MARK: - SettingsStorage
extension SharedStorageImpl: SettingsStorage {
    var isLogin: Bool {
        get { defaults.isLogin }
        set { defaults.isLogin = newValue }
    }
}
