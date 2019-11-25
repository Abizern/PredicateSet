import XCTest
@testable import PredicateSet

final class PredicateSetTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PredicateSet().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
