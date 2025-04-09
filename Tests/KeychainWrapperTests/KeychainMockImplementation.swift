import Foundation
@testable import KeychainWrapper

final class KeychainMockImplementation: @preconcurrency KeychainImplementable {
    let service: KeychainService
    let accessGroup: String?
    
    @MainActor
    var storage = [String: String]()
    
    init(service: KeychainService, accessGroup: String?) {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    @MainActor
    func set(_ string: String, forKey key: KeychainKey) -> Bool {
        storage[key] = string
        return true
    }
    
    @MainActor
    func get(stringForKey key: KeychainKey) -> String? {
        storage[key]
    }
    
    @MainActor
    func remove(valueForKey key: KeychainKey) -> Bool {
        storage.removeValue(forKey: key)
        return true
    }
    
    
}
