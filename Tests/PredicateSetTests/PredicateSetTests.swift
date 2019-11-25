import XCTest
import PredicateSet

enum Item: Equatable {
    case a, b, c, d, e, f
}

final class PredicateSetTests: XCTestCase {
    func testEmpty() {
        XCTAssertFalse(empty()(Item.a))
        XCTAssertFalse(empty()(Item.b))
        XCTAssertFalse(empty()(Item.c))
    }

    func testUniverse() {
        XCTAssertTrue(universe()(Item.a))
        XCTAssertTrue(universe()(Item.b))
        XCTAssertTrue(universe()(Item.c))
    }

    func testPredicate() {
        let set: PredicateSet<Int> = { $0.isMultiple(of: 2)}
        XCTAssertTrue(set(0))
        XCTAssertFalse(set(1))
        XCTAssertTrue(set(2))
        XCTAssertFalse(set(3))
        XCTAssertTrue(set(4))
        XCTAssertFalse(set(5))
    }

    func testPure() {
        let set = pure(Item.a)
        XCTAssertTrue(set(.a))
        XCTAssertFalse(set(.b))
        XCTAssertFalse(set(.c))
    }

    func testElements() {
        let set = elementSet(Item.a, .c)
        XCTAssertTrue(set(Item.a))
        XCTAssertFalse(set(.b))
        XCTAssertTrue(set(.c))
    }

    func testElementArray() {
        let set = elementSet([Item.a, .c])
        XCTAssertTrue(set(Item.a))
        XCTAssertFalse(set(.b))
        XCTAssertTrue(set(.c))
    }

    func testComplement() {
        let set = pure(Item.b)
        let complementSet = complement(set)
        XCTAssertTrue(complementSet(.a))
        XCTAssertFalse(complementSet(.b))
        XCTAssertTrue(complementSet(.c))
    }

    func testUnion() {
        let lhs = pure(Item.b)
        let rhs = elementSet(Item.e, .f)
        let set = union(lhs, rhs)
        XCTAssertFalse(set(.a))
        XCTAssertTrue(set(.b))
        XCTAssertFalse(set(.c))
        XCTAssertFalse(set(.d))
        XCTAssertTrue(set(.e))
        XCTAssertTrue(set(.f))
    }

    func testIntersection() {
        let lhs = elementSet(Item.b, .c, .d)
        let rhs = elementSet(Item.c, .d, .e)
        let set = intersection(lhs, rhs)
        XCTAssertFalse(set(.b))
        XCTAssertTrue(set(.c))
        XCTAssertTrue(set(.d))
        XCTAssertFalse(set(.e))
    }

    func testDifference() {
        let lhs = elementSet(Item.b, .c, .d)
        let rhs = elementSet(Item.c, .d, .e)
        let set = difference(lhs, rhs)
        XCTAssertFalse(set(.a))
        XCTAssertTrue(set(.b))
        XCTAssertFalse(set(.c))
        XCTAssertFalse(set(.d))
        XCTAssertFalse(set(.e))
        XCTAssertFalse(set(.f))
    }

    func testSymmetricDifference() {
        let lhs = elementSet(Item.b, .c, .d)
        let rhs = elementSet(Item.c, .d, .e)
        let set = symmetricDifference(lhs, rhs)
        XCTAssertFalse(set(.a))
        XCTAssertTrue(set(.b))
        XCTAssertFalse(set(.c))
        XCTAssertFalse(set(.d))
        XCTAssertTrue(set(.e))
        XCTAssertFalse(set(.f))
    }

    func testCartesianProduct() {
        let lhs = elementSet(Item.b, .c)
        let rhs = elementSet(1, 2)
        let set = cartesianProduct(lhs, rhs)
        XCTAssertFalse(set((.a, 1)))
        XCTAssertTrue(set((.b, 1)))
        XCTAssertTrue(set((.b, 2)))
        XCTAssertTrue(set((.c, 1)))
        XCTAssertTrue(set((.c, 2)))
        XCTAssertFalse(set((.c, 3)))
    }

    func testContramap() {
        let original = elementSet("2", "3")
        let set = contramap(original) { (n: Int) in String(describing: n) }
        XCTAssertFalse(set(1))
        XCTAssertTrue(set(2))
        XCTAssertTrue(set(3))
        XCTAssertFalse(set(4))
    }
}

