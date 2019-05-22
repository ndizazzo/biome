import XCTest
@testable import Biome

class BiomeGroupTests: XCTestCase {
    let jsonBiomeDecoder = JSONDecoder()
    let plistBiomeDecoder = PropertyListDecoder()
    let testBiome = TestBiome(identifier: "TestBiome", testItem1: "", testItem2: 0, testItem3: 0.0, testItem4: false)

    func testCreatingGroup() {
        let group = BiomeGroup<TestBiome>()
        XCTAssertEqual(group.biomeCount, 0)
    }

    func testInsertingBiome() {
        let group = BiomeGroup<TestBiome>()

        try! group.insert(testBiome)
        XCTAssertEqual(group.biomeCount, 1)
    }

    func testInsertingBiomes() {
        let group = BiomeGroup<TestBiome>()

        try! group.insert(contentsOf: [testBiome])
        XCTAssertEqual(group.biomeCount, 1)
    }

    func testInsertingDuplicateBiomeThrows() {
        let group = BiomeGroup<TestBiome>()

        try! group.insert(testBiome)
        XCTAssertEqual(group.biomeCount, 1)

        XCTAssertThrowsError(try group.insert(testBiome))
    }

    func testInsertingMultipleDuplicateBiomesThrows() {
        let group = BiomeGroup<TestBiome>()

        try! group.insert(testBiome)
        XCTAssertEqual(group.biomeCount, 1)

        XCTAssertThrowsError(try group.insert(contentsOf: [testBiome]))
    }

    func testRemovingBiome() {
        let group = BiomeGroup<TestBiome>()
        try! group.insert(testBiome)
        XCTAssertEqual(group.biomeCount, 1)

        group.removeBiome(with: "TestBiome")
        XCTAssertEqual(group.biomeCount, 0)
    }

    func testRemovingNonExistentBiome() {
        let group = BiomeGroup<TestBiome>()
        group.removeBiome(with: "I don't exist")
    }

    func testSelectingBiome() {
        let group = BiomeGroup<TestBiome>()
        try! group.insert(testBiome)
        group.switchTo(0)

        let current = group.current()
        XCTAssertNotNil(current)
        XCTAssertEqual(current!.identifier, testBiome.identifier)
    }

    func testClearingSelection() {
        let group = BiomeGroup<TestBiome>()
        try! group.insert(testBiome)
        group.switchTo(0)

        let current = group.current()
        XCTAssertNotNil(current)

        group.switchTo(nil)
        XCTAssertNil(group.current())
    }

    func testErasedCurrent() {
        let group = BiomeGroup<TestBiome>()
        try! group.insert(testBiome)
        group.switchTo(0)

        XCTAssertNotNil(group.erasedCurrent())
    }

    func testAnyBiomeGroupWrapper() {
        let group = BiomeGroup<TestBiome>()
        let anyGroup = AnyBiomeGroup(group: group)
        try! group.insert(testBiome)
        group.switchTo(0)

        XCTAssertNotNil(anyGroup.current())

        let castedAnyBiomeGroup: TestBiome? = anyGroup.current()
        XCTAssertNotNil(castedAnyBiomeGroup)

        group.switchTo(nil)
        let improperlyCastAnyBiomeGroup: SecondTestBiome? = anyGroup.current()
        XCTAssertNil(improperlyCastAnyBiomeGroup)
    }
}

