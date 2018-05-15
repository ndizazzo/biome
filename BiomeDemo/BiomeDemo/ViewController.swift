//
//  ViewController.swift
//  Biome
//
//  Created by ndizazzo on 03/01/2017.
//  Copyright (c) 2017 ndizazzo. All rights reserved.
//

import UIKit
import Biome

struct APIBiome: Biome {
    var identifier: String
    var keyCount: Int { return 1 }

    var baseURL: String
}

class ViewController: UIViewController {
    @IBOutlet weak var showBiomesButton: UIButton?
    @IBOutlet weak var apiURLLabel: UILabel?
    
    var dataSource: BiomeDataSource<APIBiome>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBiomesButton?.layer.cornerRadius = 3.0

        guard let currentBiome = manager.current(for: APIBiome.self) else { return }
        self.setupBiomeInfo(biome: currentBiome)
    }
    
    @IBAction func showBiomes(_ sender: Any) {
        self.dataSource = BiomeDataSource(biomeManager: manager)
        
        manager.delegate = self
        
        let tableViewController = UITableViewController(style: .plain)
        tableViewController.tableView.delegate = self.dataSource
        tableViewController.tableView.dataSource = self.dataSource
        tableViewController.title = "Registered Biomes"
        
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }

    func setupBiomeInfo(biome: APIBiome) {
        self.apiURLLabel?.text = biome.baseURL
    }
}

extension ViewController: BiomeManagerDelegate {
    func switched(to biome: Biome?) {
        guard let currentBiome = manager.current(for: APIBiome.self) else { return }
        self.setupBiomeInfo(biome: currentBiome)
    }
}
