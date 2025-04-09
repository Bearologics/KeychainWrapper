import Foundation

protocol KeychainImplementable: Sendable {
    var service: KeychainService { get }
    var accessGroup: String? { get }

    func set(_ string: String, forKey key: KeychainKey) -> Bool
    func get(stringForKey key: KeychainKey) -> String?
    func remove(valueForKey key: KeychainKey) -> Bool
}
