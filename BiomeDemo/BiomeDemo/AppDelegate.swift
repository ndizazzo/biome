//
//  AppDelegate.swift
//  Biome
//
//  Created by ndizazzo on 03/01/2017.
//  Copyright (c) 2017 ndizazzo. All rights reserved.
//

import UIKit
import Biome

let manager = BiomeManager()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.createExampleBiomes()
        return true
    }
    
    func createExampleBiomes() {
        let plistDecoder = PropertyListDecoder()
        let jsonDecoder = JSONDecoder()

        do {
            let devPath = Bundle.main.url(forResource: "Development", withExtension: "json")!
            let stagePath = Bundle.main.url(forResource: "Staging", withExtension: "plist")!
            let prodPath = Bundle.main.url(forResource: "Production", withExtension: "plist")!

            let devAPI = try APIBiome.load(fromPath: devPath, using: jsonDecoder)
            let stagingAPI = try APIBiome.load(fromPath: stagePath, using: plistDecoder)
            let prodAPI = try APIBiome.load(fromPath: prodPath, using: plistDecoder)

            try manager.register(devAPI, stagingAPI, prodAPI)
        } catch let error {
            assert(false, "Couldn't create a Biome: \(error)")
        }
    }
}
