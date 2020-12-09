import XCTest
@testable import ProModule

final class ProModuleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ProModule().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
