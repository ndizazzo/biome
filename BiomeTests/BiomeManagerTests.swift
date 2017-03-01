import XCTest
import Biome

class BiomeManagerTests: XCTestCase {
    
    var testBiome: Biome!
    var biomeManager: BiomeManager! = BiomeManager.shared
    
    override func setUp() {
        super.setUp()
        
        biomeManager.clear()
        
        self.testBiome = Biome(named: "test")
        self.testBiome.set("testKey", value: "testValue")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRegisterBiome() {
        XCTAssertEqual(biomeManager.count, 0)
        
        try! BiomeManager.register(testBiome)
        XCTAssertEqual(biomeManager.count, 1)
    }
    
    func testRegisteringDuplicateBiome() {
        XCTAssertEqual(biomeManager.count, 0)
        
        try! BiomeManager.register(testBiome)
        XCTAssertEqual(biomeManager.count, 1)
        
        XCTAssertThrowsError(
            try BiomeManager.register(testBiome),
            "'register' didnt throw expected error",
            { error in XCTAssertEqual(error as! BiomeError, .previouslyRegistered) }
        )
    }
    
    func testRemoveBiome() {
        try! BiomeManager.register(testBiome)
        XCTAssertEqual(biomeManager.count, 1)
        
        try! BiomeManager.remove(testBiome)
        XCTAssertEqual(biomeManager.count, 0)
    }
    
    func testRemovingNonexistantBiome() {
        XCTAssertThrowsError(
            try BiomeManager.remove(testBiome),
            "'remove' didnt throw expected error",
            { error in XCTAssertEqual(error as! BiomeError, .notRegistered) }
        )
    }
    
    func testClearingBiomes() {
        try! BiomeManager.register(testBiome)
        try! BiomeManager.register(Biome(named: "another one"))
        XCTAssertEqual(biomeManager.count, 2)
        
        biomeManager.clear()
        
        XCTAssertEqual(biomeManager.count, 0)
        XCTAssertEqual(biomeManager.current, nil)
    }
    
    func testGatheringKeysAcrossBiomes() {
        let firstBiome = Biome(named: "first")
        let secondBiome = Biome(named: "second")
        
        firstBiome.set("firstKey", value: 1)
        secondBiome.set("secondKey", value: 2)
        
        try! BiomeManager.register(firstBiome)
        try! BiomeManager.register(secondBiome)
        
        XCTAssertEqual(BiomeManager.shared.count, 2)
        XCTAssertEqual(BiomeManager.shared.keys.count, 2)
        XCTAssertEqual(Array(BiomeManager.shared.keys), ["firstKey", "secondKey"])
    }
    
    func testCurrentBiomeIsSetWhenRegistering() {
        try! BiomeManager.register(testBiome)
        XCTAssertEqual(biomeManager.current, testBiome)
    }
    
    func testCurrentBiomeRemainsSetWhenRegistering() {
        try! BiomeManager.register(testBiome)
        try! BiomeManager.register(Biome(named: "second biome"))
        XCTAssertEqual(biomeManager.current, testBiome)
    }
}
