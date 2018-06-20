import XCTest
@testable import Biome

class HashableTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTypeCanBeConvertedToHashable() {
        let myInt = 5
        let b = createHashable(myInt)
        let aaa = type(of: b) == type(of: HashableType<Int>())
        XCTAssertTrue(aaa)
    }

    // Re-enable for Swift 4.2 / Xcode 10
    func testHashableTypeHasher() {
        let myInt = 5
        let hashable = createHashable(myInt)
        let deterministicHash = hashable.hashValue

        // SWIFT_DETERMINISTIC_HASHING is ENABLED in the BiomeTests scheme for this to be consistent across runs.
        XCTAssertEqual(deterministicHash, -5648306562266618760)
    }

    func testEquality() {
        let myInt = 5
        let hashable1 = createHashable(myInt)
        let hashable2 = createHashable(myInt)
        XCTAssertEqual(hashable1, hashable2)
    }
}
