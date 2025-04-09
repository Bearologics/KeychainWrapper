import XCTest
@testable import KeychainWrapper

final class KeychainWrapperTests: XCTestCase {
    
    private var sut: KeychainWrapper!
    
    override func setUp() {
        super.setUp()
        sut = KeychainWrapper(implementation: KeychainMockImplementation(service: "unitTests", accessGroup: nil))
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    @MainActor
    func test_setValue_succeeds() async throws {
        let value = "test-value"
        let key = "test-key"
        let success = sut.set(value, forKey: key)
        XCTAssertTrue(success)
        
        let result = sut.get(stringForKey: key)
        
        XCTAssertEqual(value, result)
    }
    
    @MainActor
    func test_getValue_subscript_succeeds() async throws {
        let value = "test-value"
        let key = "test-key"
        let success = sut.set(value, forKey: key)
        XCTAssertTrue(success)
        
        let result = sut[key]
        
        XCTAssertEqual(value, result)
    }
    
    @MainActor
    func test_removeValue_succeeds() async throws {
        let value = "test-value"
        let key = "test-key"
        let success = sut.set(value, forKey: key)
        XCTAssertTrue(success)
        
        let result = sut.remove(valueForKey: key)
        XCTAssertTrue(result)
        
        let existing = sut.get(stringForKey: key)
        XCTAssertNil(existing)
    }
}
