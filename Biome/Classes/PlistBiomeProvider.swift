//
//  PlistBiomeProvider.swift
//  Biome
//
//  Created by Nick DiZazzo on 2017-02-28.
//  Copyright © 2017 Nick DiZazzo. All rights reserved.
//

import Foundation

public class PlistBiomeProvider: BiomeProvider {
    
    var plistFileName: String
    var bundle: Bundle
    
    public var biomeName: String { get { return self.plistFileName } }
    
    public init(bundle: Bundle, filename: String) {
        self.plistFileName = filename
        self.bundle = bundle
    }
    
    public func mappedPropertyDictionary() -> [String : Any] {
        if let path = self.bundle.path(forResource: self.plistFileName, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict
        }
        
        return [:]
    }
}
