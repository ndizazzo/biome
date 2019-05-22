//
//  BiomeGroup.swift
//  Biome
//
//  Created by Nick DiZazzo on 2018-06-13.
//  Copyright © 2018 Nick DiZazzo. All rights reserved.
//

import Foundation

internal protocol AnyBiomeGroupProtocol {
    var biomeType: Biome.Type { get }
    var biomeCount: Int { get }
    func erasedCurrent() -> Biome?
    func switchTo(_ index: Int?)
}

extension AnyBiomeGroupProtocol where Self: BiomeGroupProtocol {
    var biomeType: Biome.Type {
        return BiomeType.self
    }
}

internal protocol BiomeGroupProtocol: AnyBiomeGroupProtocol {
    associatedtype BiomeType: Biome
    func current() -> BiomeType?
}

internal struct AnyBiomeGroup {
    var _storage: AnyBiomeGroupProtocol

    init<Group: AnyBiomeGroupProtocol>(group: Group) {
        _storage = group
    }

    func current() -> Biome? {
        return _storage.erasedCurrent()
    }

    func current<BiomeType: Biome>() -> BiomeType? {
        if BiomeType.self == _storage.biomeType {
            return _storage.erasedCurrent() as! BiomeType?
        }

        return nil
    }
}

/// A class that collects similarly-typed Biome objects together, and maintains a current selection for whichever one should be active.
internal final class BiomeGroup<BiomeType: Biome>: BiomeGroupProtocol {
    enum Error: LocalizedError {
        case duplicateBiome
    }

    private var biomes = SelectableArray<BiomeType>()
    var biomeCount: Int { return biomes.count }
    var biomeData: [BiomeData] {
        return biomes.map {
            return (identifier: $0.identifier, keys: $0.keyCount)
        }
    }

    func insert(_ biome: BiomeType) throws {
        let alreadyExists = biomes.firstIndex(where: { innerBiome -> Bool in
            return innerBiome.identifier == biome.identifier
        }) != nil

        guard !alreadyExists else { throw Error.duplicateBiome }

        biomes.insert(biome, at: biomes.endIndex)
    }

    func insert(contentsOf collection: [BiomeType]) throws {
        let identifierSet = collection.map { $0.identifier }
        let existingBiomes = biomes.filter { identifierSet.contains($0.identifier) }

        guard existingBiomes.count == 0 else { throw Error.duplicateBiome }

        biomes.insert(contentsOf: collection, at: biomes.endIndex)
    }

    func removeBiome(with identifier: String) {
        guard let removalIndex = biomes.firstIndex(where: { biome -> Bool in
            return biome.identifier == identifier
        }) else { return }


        _ = biomes.remove(at: removalIndex)
    }

    func current() -> BiomeType? {
        return biomes.current
    }

    func erasedCurrent() -> Biome? {
        return biomes.current
    }

    func switchTo(_ index: Int?) {
        guard let biomeIndex = index else {
            biomes.deselect()
            return
        }

        biomes.select(index: biomeIndex)
    }
}
