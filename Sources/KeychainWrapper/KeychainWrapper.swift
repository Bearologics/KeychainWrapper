import Foundation

public typealias KeychainService = String
public typealias KeychainKey = String
typealias KeychainQuery = [String: Any]

public final class KeychainWrapper: Sendable {
    let implementation: KeychainImplementable
    
    public init(service: String, accessGroup: String? = nil) {
        self.implementation = KeychainImplementation(service: service, accessGroup: accessGroup)
    }
    
    init(implementation: KeychainImplementable) {
        self.implementation = implementation
    }
        
    @discardableResult
    public func set(_ string: String, forKey key: KeychainKey) -> Bool {
        implementation.set(string, forKey: key)
    }
    
    public func get(stringForKey key: KeychainKey) -> String? {
        implementation.get(stringForKey: key)
    }
    
    @discardableResult
    public func remove(valueForKey key: KeychainKey) -> Bool {
        implementation.remove(valueForKey: key)
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
