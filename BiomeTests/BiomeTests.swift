import XCTest
import Biome

struct TestBiome: Biome {
    var identifier: String
    var keyCount: Int { return 4 }

    var testItem1: String
    var testItem2: Int
    var testItem3: Double
    var testItem4: Bool
}

struct SecondTestBiome: Biome {
    var identifier: String { return "SecondTestBiome" }
    var keyCount: Int { return 0 }
}

class BiomeTests: XCTestCase {
    let jsonBiomeDecoder = JSONDecoder()
    let plistBiomeDecoder = PropertyListDecoder()

    func testCanLoadFromJSON() {
        let biomeURL = Bundle(for: BiomeTests.self).url(forResource: "testProperties", withExtension: "json")
        let biome = try! TestBiome.load(fromPath: biomeURL, using: jsonBiomeDecoder)

        XCTAssertNotNil(biome)
        XCTAssertEqual(biome.testItem1, "item1")
        XCTAssertEqual(biome.testItem2, 0)
        XCTAssertEqual(biome.testItem3, 1.0)
        XCTAssertFalse(biome.testItem4)
    }

    func testCanLoadFromPlist() {
        let biomeURL = Bundle(for: BiomeTests.self).url(forResource: "testProperties", withExtension: "plist")
        let biome = try! TestBiome.load(fromPath: biomeURL, using: plistBiomeDecoder)

        XCTAssertNotNil(biome)
        XCTAssertEqual(biome.identifier, "TestPlistBiome")
        XCTAssertEqual(biome.testItem1, "item1")
        XCTAssertEqual(biome.testItem2, 0)
        XCTAssertEqual(biome.testItem3, 1.0)
        XCTAssertFalse(biome.testItem4)
    }
}
