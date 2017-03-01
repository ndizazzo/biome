//
//  Biome.swift
//  Biome
//
//  Created by Nick DiZazzo on 2017-02-28.
//  Copyright © 2017 Nick DiZazzo. All rights reserved.
//

import Foundation

// MARK: -
// MARK: BiomeProvider

public protocol BiomeProvider {
    var biomeName: String { get }
    func mappedPropertyDictionary() -> [String: Any]
}

// MARK: -
// MARK: BiomeManager

public enum BiomeError: Error {
    case previouslyRegistered
    case notRegistered
}

public protocol BiomeManagerDelegate {
    func switched(to biome: Biome?)
}

public class BiomeManager {
    public static let shared = BiomeManager()
    
    internal var biomes: Set<Biome> = Set<Biome>()
    
    public var count: Int { get { return self.biomes.count } }
    public var current: Biome? { didSet { self.delegate?.switched(to: self.current) } }
    public var delegate: BiomeManagerDelegate?
    
    public var keys: Set<String> {
        get {
            var unversalKeys = Set<String>()
            
            for biome in self.biomes {
                biome.properties.keys.forEach { unversalKeys.insert($0) }
            }
            
            return unversalKeys
        }
    }
    
    public static func register(_ biome: Biome) throws {
        if shared.biomes.contains(biome) {
            throw BiomeError.previouslyRegistered
        }
        
        if shared.count == 0 {
           shared.current = biome
        }
        
        shared.biomes.insert(biome)
    }
    
    public static func remove(_ biome: Biome) throws {
        guard shared.biomes.contains(biome) else {
            throw BiomeError.notRegistered
        }
        
        shared.biomes.remove(biome)
    }
    
    public func clear() {
        self.current = nil
        self.biomes.removeAll()
    }
}

// MARK: -
// MARK: Biome
public class Biome {
    fileprivate var properties: [String: Any] = [:]
    
    public private(set) var name: String = ""
    public var count: Int { get { return properties.keys.count } }
    
    public init(named biomeName: String) {
        self.name = biomeName
    }
    
    public init(with provider: BiomeProvider) {
        self.name = provider.biomeName
        self.properties = provider.mappedPropertyDictionary()
    }
    
    public func get(_ key: String) -> Any? {
        return self.properties[key]
    }
    
    public func set(_ key: String, value: Any?) {
        self.properties[key] = value
    }
}

// MARK: -
// MARK: Equatable
extension Biome: Equatable {
    public static func ==(lhs: Biome, rhs: Biome) -> Bool {
        return lhs.name == rhs.name
    }
}

// MARK: -
// MARK: Hashable
extension Biome: Hashable {
    public var hashValue: Int { get { return self.name.hash } }
}
