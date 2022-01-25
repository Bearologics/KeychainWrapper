import XCTest
@testable import KeychainWrapper

final class KeychainWrapperTests: XCTestCase {
    
    private var sut: KeychainWrapper!
    
    override func setUp() {
        super.setUp()
        sut = KeychainWrapper(service: "unitTests")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
