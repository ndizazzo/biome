//
//  SelectableCollection.swift
//  Biome
//
//  Created by Nick DiZazzo on 2018-06-13.
//  Copyright © 2018 Nick DiZazzo. All rights reserved.
//

import Foundation

public protocol SelectableCollection {
    associatedtype Index
    associatedtype Element

    var currentIndex: Index? { get set }
    var current: Element? { get }
    mutating func select(index: Index)
    mutating func deselect()
}

public struct SelectableArray<Element> {
    public typealias StorageType = [Element]
    public typealias Index = StorageType.Index
    public typealias Iterator = StorageType.Iterator

    fileprivate var _storage: StorageType
    public var currentIndex: Index?

    public init() {
        _storage = []
    }

    public init(_ array: [Element]) {
        _storage = array
    }
}

extension SelectableArray: Collection {
    public var startIndex: SelectableArray<Element>.StorageType.Index {
        return _storage.startIndex
    }

    public var endIndex: SelectableArray<Element>.StorageType.Index {
        return _storage.endIndex
    }

    public func makeIterator() -> IndexingIterator<Array<Element>> {
        return _storage.makeIterator()
    }
}

extension SelectableArray: MutableCollection {
    public subscript(position: SelectableArray<Element>.StorageType.Index) -> Element {
        get { return _storage[position] }
        set(newValue) { _storage[position] = newValue }
    }
}

extension SelectableArray: SelectableCollection {
    public var current: Element? {
        guard let index = currentIndex else { return nil }
        guard index < _storage.endIndex else { return nil }
        return self[index]
    }

    public mutating func insert(_ newElement: Element, at i: Index) {
        // if i is lte the selected index, modifiy selected index to be +1
        if currentIndex != nil && i <= currentIndex! { currentIndex! += 1 }

        _storage.insert(newElement, at: i)
    }

    public mutating func insert<C>(contentsOf newElements: C, at i: Index) where C : Collection, Element == C.Element {
        // if i is lte the selected index, modifiy selected index to be +n
        if currentIndex != nil && i <= currentIndex! { currentIndex! += newElements.count }

        _storage.insert(contentsOf: newElements, at: i)
    }

    public mutating func remove(at position: Index) -> Element {
        // we removed the selected index
        if currentIndex != nil && position == currentIndex! { currentIndex = nil }

        // if the selected index is gte position, modify selected index to be -1
        if currentIndex != nil && currentIndex! > position { currentIndex! -= 1 }

        return _storage.remove(at: position)
    }

    public mutating func select(index: Index) {
        currentIndex = index
    }

    public mutating func deselect() {
        currentIndex = nil
    }
}

extension SelectableArray: RandomAccessCollection { }

extension SelectableArray: RangeReplaceableCollection { }
