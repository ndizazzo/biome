//
//  HashableType.swift
//  Biome
//
//  Created by Nick DiZazzo on 2018-06-06.
//  Copyright © 2018 Nick DiZazzo. All rights reserved.
//

import Foundation

// MARK: -
// MARK: HashableType

public struct HashableType<Type>: Hashable {
    public var hashValue: Int {
        return "\(type)".hashValue
    }

    let type = Type.self

    init() {}

    public static func ==(lhs: HashableType<Type>, rhs: HashableType<Type>) -> Bool {
        return lhs.type == rhs.type
    }

    /// Swift 4.2 implementation of deprecated 'hashValue'
    ///
    /// - Parameter hasher: The hasher to use to combine values
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(type)")
    }
}

internal func createHashable<Type>(_ x: Type? = nil) -> HashableType<Type> {
    return HashableType<Type>()
}
