import XCTest
@testable import Biome

final class TestBiomeDelegate: BiomeManagerDelegate {
    var called: Bool = false

    func switched(to biome: Biome?) {
        called = true
    }
}

class BiomeManagerTests: XCTestCase {
    var testBiome: TestBiome!
    let jsonBiomeDecoder = JSONDecoder()
    var manager: BiomeManager!
    var biomeDelegate: TestBiomeDelegate!
    
    override func setUp() {
        super.setUp()

        biomeDelegate = TestBiomeDelegate()
        manager = BiomeManager()
        manager.delegate = biomeDelegate

        let biomeURL = Bundle(for: BiomeManagerTests.self).url(forResource: "testProperties", withExtension: "json")
        testBiome = try! TestBiome.load(fromPath: biomeURL, using: jsonBiomeDecoder)
    }
    
    override func tearDown() {
        manager.delegate = nil
        manager = nil

        super.tearDown()
    }
    
    func testRegisterBiome() {
        try! manager.register(testBiome)
        XCTAssertEqual(manager.groupCount, 1)
        XCTAssertEqual(manager.biomeCount, 1)
    }

    func testRegisterBiomeSelectsFirstAdded() {
        try! manager.register(testBiome)
        XCTAssertNotNil(manager.current(for: TestBiome.self))
    }

    func testRegisterMultipleTypeBiomes() {
        let testBiome2 = SecondTestBiome()
        try! manager.register(testBiome!)
        try! manager.register(testBiome2)

        XCTAssertEqual(manager.groupCount, 2)
        XCTAssertEqual(manager.biomeCount, 2)
    }
    
    func testRemoveBiome() {
        let testBiome2 = SecondTestBiome()
        try! manager.register(testBiome!)
        try! manager.register(testBiome2)

        XCTAssertEqual(manager.groupCount, 2)
        XCTAssertEqual(manager.biomeCount, 2)

        manager.remove(with: testBiome)
        manager.remove(with: SecondTestBiome.self, identifier: testBiome2.identifier)

        XCTAssertEqual(manager.groupCount, 2)
        XCTAssertEqual(manager.biomeCount, 0)
    }

    func testUnregisterGroup() {
        let testBiome2 = SecondTestBiome()
        try! manager.register(testBiome!)
        try! manager.register(testBiome2)

        XCTAssertEqual(manager.groupCount, 2)
        XCTAssertEqual(manager.biomeCount, 2)

        manager.unregister(type: SecondTestBiome.self)
        manager.unregister(type: TestBiome.self)

        XCTAssertEqual(manager.groupCount, 0)
        XCTAssertEqual(manager.biomeCount, 0)
    }

    func testUnregisterGroupCallsDelegateIfSelected() {
        try! manager.register(testBiome!)
        let selectedBiome = manager.current(for: TestBiome.self)
        XCTAssertNotNil(selectedBiome)
        XCTAssertTrue(biomeDelegate.called)

        let newDelegate = TestBiomeDelegate()
        manager.delegate = newDelegate

        manager.unregister(type: TestBiome.self)
        let newSelectedBiome = manager.current(for: TestBiome.self)
        XCTAssertNil(newSelectedBiome)
        XCTAssertTrue(newDelegate.called)
    }

    func testCurrentSubscript() {
        try! manager.register(testBiome!)

        let current = manager[TestBiome.self]
        XCTAssertNotNil(current)
        XCTAssertEqual(current?.identifier, testBiome.identifier)
    }

    func testDelegateIsCalledWhenSwitchingBiomes() {
        let testBiome1 = TestBiome(identifier: "first", testItem1: "", testItem2: 0, testItem3: 0.0, testItem4: false)
        let testBiome2 = TestBiome(identifier: "second", testItem1: "", testItem2: 0, testItem3: 0.0, testItem4: false)
        try! manager.register(testBiome1)
        try! manager.register(testBiome2)

        let newDelegate = TestBiomeDelegate()
        manager.delegate = newDelegate

        XCTAssertFalse(newDelegate.called)

        try! manager.select(type: TestBiome.self, index: 1)

        XCTAssertTrue(newDelegate.called)
    }

    func testDelegateIsCalledWhenClearingBiome() {
        let testBiome2 = SecondTestBiome()
        try! manager.register(testBiome!)
        try! manager.register(testBiome2)

        manager.clear()

        XCTAssertTrue(biomeDelegate.called)
    }

    func testSwitchingBiomesChangesFromPreviousToNext() {
        let testBiome2 = TestBiome(identifier: "new_identifier", testItem1: "test", testItem2: 1, testItem3: 4.0, testItem4: false)
        try! manager.register(testBiome!)
        try! manager.register(testBiome2)

        let selectedBiome: TestBiome? = manager.current(for: TestBiome.self)
        XCTAssertNotNil(selectedBiome)
        XCTAssertEqual(selectedBiome!.identifier, testBiome!.identifier)

        try! manager.select(type: TestBiome.self, index: 1)

        let newSelected = manager[TestBiome.self]
        XCTAssertNotNil(newSelected)
        XCTAssertEqual(newSelected!.identifier, testBiome2.identifier)
    }
    
    func testClearingBiomes() {
        try! manager.register(testBiome)
        XCTAssertEqual(manager.biomeCount, 1)
        XCTAssertEqual(manager.groupCount, 1)

        manager.clear()

        XCTAssertEqual(manager.biomeCount, 0)
        XCTAssertEqual(manager.groupCount, 0)
    }
}
