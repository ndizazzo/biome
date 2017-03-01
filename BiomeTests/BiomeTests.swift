import XCTest
import Biome

final class TestBiomeProvider: BiomeProvider {
    var biomeName: String = "testBiome1"
    
    func mappedPropertyDictionary() -> [String : Any] {
        return ["testProviderValue": 1]
    }
}

class BiomeTests: XCTestCase {
    var testBiome: Biome!
    
    override func setUp() {
        super.setUp()
        
        self.testBiome = Biome(named: "test")
        self.testBiome.set("testKey", value: "testValue")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBiomeName() {
        XCTAssert(testBiome.name == "test")
    }
    
    func testBiomeCount() {
        XCTAssertEqual(self.testBiome.count, 1)
    }
    
    func testGettingBiomeValue() {
        try! BiomeManager.register(testBiome)
        let testValue = testBiome.get("testKey") as! String
        XCTAssertEqual(testValue, "testValue")
    }
    
    func testBiomeEquality() {
        let first = Biome(named: "first")
        let second = Biome(named: "second")
        let duplicate = Biome(named: "first")
        
        XCTAssertEqual(first, duplicate)
        XCTAssertEqual(first, first)
        XCTAssertNotEqual(first, second)
    }
    
    func testBiomeWithProvider() {
        let biome = Biome(with: TestBiomeProvider())
        XCTAssertEqual(biome.name, "testBiome1")
        XCTAssertEqual(biome.count, 1)
        
        let value = biome.get("testProviderValue") as! Int
        XCTAssertEqual(value, 1)
    }
    
}
