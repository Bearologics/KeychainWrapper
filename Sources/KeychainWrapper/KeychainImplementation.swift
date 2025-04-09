import Foundation

final class KeychainImplementation: KeychainImplementable {
    let service: KeychainService
    let accessGroup: String?
    
    init(service: KeychainService, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }

    func set(_ string: String, forKey key: KeychainKey) -> Bool {
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
    
    func get(stringForKey key: KeychainKey) -> String? {
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
    
    func remove(valueForKey key: KeychainKey) -> Bool {
        let query = keychainQuery(withService: service, forKey: key)
        return SecItemDelete(query as CFDictionary) == noErr
    }
    
    private func keychainQuery(withService service: KeychainService, forKey key: KeychainKey) -> KeychainQuery {
        var keychainQueryDict: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
        
        if let accessGroup = accessGroup {
            keychainQueryDict[kSecAttrAccessGroup as String] = accessGroup
        }
        
        return keychainQueryDict
    }
}
