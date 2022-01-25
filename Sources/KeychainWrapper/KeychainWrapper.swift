import Foundation

public typealias KeychainService = String
public typealias KeychainKey = String

public class KeychainWrapper {
    private let service: String
    
    public init(service: String) {
        self.service = service
    }
    
    private func keychainQuery(withService service: KeychainService, forKey key: KeychainKey) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
    }
    
    @discardableResult
    public func set(_ string: String, forKey key: KeychainKey) -> Bool {
        var query = keychainQuery(withService: service, forKey: key)
        
        guard let data = string.data(using: .utf8) else {
            return false
        }
        
        guard SecItemCopyMatching(query as CFDictionary, nil) == noErr else {
            query[kSecValueData as String] = data
            let status = SecItemAdd(query as CFDictionary, nil)
            return status == errSecSuccess
        }
        
        return SecItemUpdate(
            query as CFDictionary,
            NSDictionary(dictionary: [kSecValueData: data])
        ) == errSecSuccess
    }
    
    public func get(stringForKey key: KeychainKey) -> String? {
        var query = keychainQuery(withService: service, forKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var result: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &result) == noErr else {
            return nil
        }
        
        guard
            let dictionary = result as? [String: Any],
            let data = dictionary[kSecValueData as String] as? Data
        else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    @discardableResult
    public func remove(valueForKey key: KeychainKey) -> Bool {
        let query = keychainQuery(withService: service, forKey: key)
        return SecItemDelete(query as CFDictionary) == noErr
    }
    
    public subscript(key: KeychainKey) -> String? {
        get {
            return get(stringForKey: key)
        } set {
            guard let value = newValue else {
                remove(valueForKey: key)
                return
            }
            set(value, forKey: key)
        }
    }
}
