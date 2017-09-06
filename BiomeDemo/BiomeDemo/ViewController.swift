//
//  ViewController.swift
//  Biome
//
//  Created by ndizazzo on 03/01/2017.
//  Copyright (c) 2017 ndizazzo. All rights reserved.
//

import UIKit
import Biome

class ViewController: UIViewController {
    @IBOutlet weak var showBiomesButton: UIButton?
    
    @IBOutlet weak var apiURLLabel: UILabel?
    
    var dataSource: BiomeDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBiomesButton?.layer.cornerRadius = 3.0

        let currentBiome = BiomeManager.shared.current

        self.setupBiomeInfo(biome: currentBiome)
    }
    
    @IBAction func showBiomes(_ sender: Any) {
        self.dataSource = BiomeDataSource(biomeManager: BiomeManager.shared)
        
        BiomeManager.shared.delegate = self
        
        let tableViewController = UITableViewController(style: .plain)
        tableViewController.tableView.delegate = self.dataSource
        tableViewController.tableView.dataSource = self.dataSource
        tableViewController.title = "Registered Biomes"
        
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }

    func setupBiomeInfo(biome: Biome?) {
        self.apiURLLabel?.text = biome?.get("api_url") as? String
    }
}

extension ViewController: BiomeManagerDelegate {
    func switched(to biome: Biome?) {
        self.setupBiomeInfo(biome: biome)
    }
}

