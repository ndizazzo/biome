//
//  Biome.swift
//  Biome
//
//  Created by Nick DiZazzo on 2018-05-11.
//  Copyright © 2018 Nick DiZazzo. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Biome

/// A simple protocol that tells the `BiomeGroup` and `BiomeManager` how to work with objects.
public protocol Biome: Codable {
    var identifier: String { get }
    var keyCount: Int { get }
}

enum BiomeError: LocalizedError {
    case missingResource
}

extension Biome {
    public static func load(fromPath url: URL?, using decoder: BridgedDecoder) throws -> Self {
        guard let url = url else { throw BiomeError.missingResource }
        
        let data = try Data(contentsOf: url)
        let biome = try decoder.decode(Self.self, from: data)
        return biome
    }
}

public typealias BiomeData = (identifier: String, keys: Int)

// MARK: -
// MARK: BridgedDecoder

public protocol BridgedDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: BridgedDecoder { }
extension PropertyListDecoder: BridgedDecoder { }
