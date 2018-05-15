//
//  BiomeManager.swift
//  Biome
//
//  Created by Nick DiZazzo on 2018-06-13.
//  Copyright © 2018 Nick DiZazzo. All rights reserved.
//

import Foundation

public protocol BiomeManagerDelegate: AnyObject {
    func switched(to biome: Biome?)
}

// MARK: -
// MARK: BiomeManager

/// A manager object that maintains a groups of active 'Biomes' created in your application.
public final class BiomeManager {
    enum Error: LocalizedError {
        /// Thrown when attempting to select a Biome at an index which is greater than the number of registered Biomes.
        case invalidBiomeIndex

        /// Thrown when no containing group matching the type of Biome is found.
        case groupNotRegistered
    }

    /// A hashable list of groups tracked by the shared manager
    private var groups: Dictionary<AnyHashable, AnyBiomeGroup> = [:]

    /// A count of the number of different types this BiomeManager is managing.
    public var groupCount: Int { return groups.count }

    /// The cumulative number of biomes managed.
    public var biomeCount: Int {
        return groups.reduce(0) { sum, group in
            return sum + group.value._storage.biomeCount
        }
    }

    /// Any object conforming to this protocol will be notified when Biome switching occurs.
    public weak var delegate: BiomeManagerDelegate?

    public init() { }

    // Shorthand for developers to get the current Biome matching the provided type.
    public subscript<BiomeType: Biome>(_ key: BiomeType.Type) -> BiomeType? {
        let hashableKey: HashableType<BiomeType> = createHashable()
        return group(for: hashableKey)?.current()
    }

    /// Fetches the BiomeGroup for the provided key.
    ///
    /// - Parameter key: A hashable type that biome groups are stored under, for later retrieval.
    /// - Returns: A BiomeGroup object corresponding to the type of Biome desired to be retrieved.
    internal func group<BiomeType: Biome>(for key: HashableType<BiomeType>) -> BiomeGroup<BiomeType>? {
        if let group = groups[key]?._storage as? BiomeGroup<BiomeType> {
            return group
        }

        return nil
    }

    /// Sets up the BiomeManager to track the provided type of Biomes, and adds each one to the group for the provided type.
    ///
    /// If the 'selected' Biome for the provided type is nil, the first biome provided is automatically
    /// selected as the current one for that group.
    ///
    /// - Parameter xs: Any number of similarly-typed Biome objects.
    public func register<BiomeType: Biome>(_ xs: BiomeType...) throws {
        let hashableBiome: HashableType<BiomeType> = createHashable()

        if let group = groups[hashableBiome]?._storage as? BiomeGroup<BiomeType> {
            try group.insert(contentsOf: xs)
        } else {
            let group = BiomeGroup<BiomeType>()
            try group.insert(contentsOf: xs)

            let anyGroup = AnyBiomeGroup(group: group)
            groups[hashableBiome] = anyGroup
        }

        if current(for: BiomeType.self) == nil {
            try select(type: BiomeType.self, index: 0)
        }
    }

    /// Removes an entire group of Biomes from being managed.
    ///
    /// - Parameter type: The type of Biomes to stop tracking.
    public func unregister<BiomeType: Biome>(type: BiomeType.Type) {
        let hashableType: HashableType<BiomeType> = createHashable()

        if let currentlySelectedType = self[type], createHashable(currentlySelectedType) == hashableType {
            delegate?.switched(to: nil)
        }

        groups[hashableType] = nil
    }

    /// Removes a Biome using a specific identifier, from the type-specific group of Biomes.
    ///
    /// - Parameters:
    ///   - type: The type of Biome to remove.
    ///   - identifier: The unique identifier of the Biome to remove.
    public func remove<BiomeType: Biome>(with type: BiomeType.Type, identifier: String) {
        let type = HashableType<BiomeType>()
        let group = self.group(for: type)
        group?.removeBiome(with: identifier)
    }


    /// Convenience method to remove a provided Biome.
    ///
    /// The type and identifier used are inferred from the provided object.
    ///
    /// - Parameter biome: The biome to remove
    public func remove<BiomeType: Biome>(with biome: BiomeType) {
        remove(with: BiomeType.self, identifier: biome.identifier)
    }

    /// Removes all Biomes and BiomeGroup objects from the manager, notifying the delegate of the removals.
    public func clear() {
        groups.removeAll()
        delegate?.switched(to: nil)
    }

    /// Convenience method to fetch the currently selected Biome given the provided type.
    ///
    /// - Parameter type: The type of Biome to query for.
    /// - Returns: The currently selected Biome, if any.
    public func current<BiomeType: Biome>(for type: BiomeType.Type) -> BiomeType? {
        return self[type]
    }

    /// Sets the Biome at the provided index as the currently selected item.
    ///
    /// - Parameters:
    ///   - type: The type of Biome to select.
    ///   - index: The index of the Biome in the group to select.
    public func select<BiomeType: Biome>(type: BiomeType.Type, index: Int) throws {
        let hashableBiome: HashableType<BiomeType> = createHashable()

        guard let group = group(for: hashableBiome) else {
            throw Error.groupNotRegistered
        }

        guard index < group.biomeCount else {
            throw Error.invalidBiomeIndex
        }

        group.switchTo(index)
        let newCurrentBiome = group.current()

        delegate?.switched(to: newCurrentBiome)
    }
}
