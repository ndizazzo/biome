import XCTest
import Biome

class PlistBiomeTests: XCTestCase {
    
    var provider: PlistBiomeProvider!
    
    override func setUp() {
        super.setUp()
        
        BiomeManager.shared.clear()
        self.provider = PlistBiomeProvider(bundle: Bundle(for: BiomeTests.self), filename: "testProperties")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProviderProperlyProvidesName() {
        XCTAssertEqual(self.provider.biomeName, "testProperties")
    }
    
    func testProviderMapsPlistProperties() {
        let dict = self.provider.mappedPropertyDictionary()
        
        XCTAssertEqual(dict.count, 4)
        
        if let first = dict["test_item_1"] as? String,
            let second = dict["test_item_2"] as? Int,
            let third = dict["test_item_3"] as? Date,
            let fourth = dict["test_item_4"] as? Bool {
                XCTAssertEqual(first, "item1")
                XCTAssertEqual(second, 0)
                XCTAssertEqual(third, Date(timeIntervalSince1970: 1488337200))
                XCTAssertEqual(fourth, false)
        } else {
            XCTFail("One or more properties were not converted properly")
        }
    }
    
    func testProviderReturnsEmptyDictionary() {
        let provider = PlistBiomeProvider(bundle: Bundle.main, filename: "doesnt_exist")
        let dict = provider.mappedPropertyDictionary()
        XCTAssert(dict.isEmpty)
    }
}
