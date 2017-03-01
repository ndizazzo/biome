//
//  AppDelegate.swift
//  Biome
//
//  Created by ndizazzo on 03/01/2017.
//  Copyright (c) 2017 ndizazzo. All rights reserved.
//

import UIKit
import Biome

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.createExampleBiomes()

        return true
    }
    
    func createExampleBiomes() {
        let devBiome = Biome(with: PlistBiomeProvider(bundle: Bundle.main, filename: "Development"))
        let stagingBiome = Biome(with: PlistBiomeProvider(bundle: Bundle.main, filename: "Staging"))
        let prodBiome = Biome(with: PlistBiomeProvider(bundle: Bundle.main, filename: "Production"))
        
        do {
            try BiomeManager.register(devBiome)
            try BiomeManager.register(stagingBiome)
            try BiomeManager.register(prodBiome)
        } catch _ {
            assert(false, "Couldn't create a Biome. Is a Plist file missing?")
        }
    }
}

