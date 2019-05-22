import XCTest
import Biome

class SelectableArrayTests: XCTestCase {
    func testCanConstructWithNothing() {
        let testArray = SelectableArray<String>()
        XCTAssert(testArray.count == 0)
    }

    func testCanConstructWithArray() {
        let testArray = SelectableArray([1, 2, 3, 4])
        XCTAssert(testArray.count == 4)
    }

    func testSubscript() {
        var testArray = SelectableArray(["one", "two"])
        XCTAssertEqual(testArray[1], "two")

        testArray[1] = "two-two"
        XCTAssertEqual(testArray[1], "two-two")
    }

    func testIndexAfter() {
        let testArray = SelectableArray([1, 2, 3, 4])
        XCTAssertEqual(testArray.index(after: 1), 2)
    }

    func testStartIndex() {
        let testArray = SelectableArray([2, 3, 4])
        XCTAssertEqual(testArray.startIndex, 0)
    }

    func testEndIndex() {
        let testArray = SelectableArray([4, 3, 2])
        XCTAssertEqual(testArray.endIndex, 3)
    }

    func testMakeIterator() {
        let testArray = SelectableArray(["aaa", "bbb"])
        let iterator = testArray.makeIterator()
        XCTAssert(iterator.elementsEqual(["aaa", "bbb"]))
    }

    func testSelectingElement() {
        var testArray = SelectableArray([0.0, 1.0, 2.0])
        testArray.select(index: 1)

        let selectedElement = testArray.current
        XCTAssertNotNil(selectedElement)

        XCTAssertEqual(selectedElement!, 1.0)
    }

    func testNilCurrentWhenSelectingNothing() {
        var testArray = SelectableArray([])
        testArray.select(index: 0)

        XCTAssertNil(testArray.current)
    }

    func testDeselectingElement() {
        var testArray = SelectableArray([0.0, 1.0, 2.0])
        testArray.select(index: 1)

        let selectedElement = testArray.current
        XCTAssertNotNil(selectedElement)

        testArray.deselect()
        XCTAssertNil(testArray.current)
    }

    func testClearingWhenElementSelected() {
        var testArray = SelectableArray([0.0, 1.0, 2.0])
        testArray.select(index: 1)

        let selectedElement = testArray.current
        XCTAssertNotNil(selectedElement)

        testArray.removeAll()

        let shouldBeNil = testArray.current
        XCTAssertNil(shouldBeNil)
    }

    func testRemovingSelectedElement() {
        var testArray = SelectableArray(["first", "second"])
        testArray.select(index: 1)

        let selectedElement = testArray.current
        XCTAssertNotNil(selectedElement)

        _ = testArray.remove(at: 1)

        let shouldBeNil = testArray.current
        XCTAssertNil(shouldBeNil)
    }

    func testRemovingElementAfterSelected() {
        var testArray = SelectableArray(["first", "second"])
        testArray.select(index: 0)

        let selectedElement = testArray.current
        XCTAssertNotNil(selectedElement)

        _ = testArray.remove(at: 1)

        let shouldBeEqual = testArray.current
        XCTAssertEqual(selectedElement, shouldBeEqual)
    }

    func testRemovingElementBeforeSelected() {
        var testArray = SelectableArray(["first", "second"])
        testArray.select(index: 1)

        let selectedElement = testArray.current
        XCTAssertNotNil(selectedElement)

        _ = testArray.remove(at: 0)

        let shouldBeEqual = testArray.current
        XCTAssertEqual(selectedElement, shouldBeEqual)
    }

    func testInsertingBeforeSelected() {
        var testArray = SelectableArray([9, 10])
        testArray.select(index: 1)
        let selectedElement = testArray.current

        testArray.insert(8, at: 0)
        let newSelectedElement = testArray.current

        XCTAssertEqual(selectedElement, newSelectedElement)
    }

    func testInsertingAfterSelected() {
        var testArray = SelectableArray([9, 10])
        testArray.select(index: 1)
        let selectedElement = testArray.current

        testArray.insert(11, at: 2)
        let newSelectedElement = testArray.current

        XCTAssertEqual(selectedElement, newSelectedElement)
    }

    func testBulkInsertingBeforeSelected() {
        var testArray = SelectableArray([9, 10])
        testArray.select(index: 0)
        let selectedElement = testArray.current

        testArray.insert(contentsOf: [7, 8], at: 0)
        let newSelectedElement = testArray.current

        XCTAssertEqual(selectedElement, newSelectedElement)
    }
}
