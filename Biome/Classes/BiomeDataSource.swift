//
//  BiomeDataSource.swift
//  Pods
//
//  Created by Nick DiZazzo on 2017-03-01.
//
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
// MARK: -
// MARK: BiomeDataSource
public class BiomeDataSource: NSObject {
    internal weak var manager: BiomeManager?
    internal var biomes: [Biome]
    
    public init(biomeManager: BiomeManager) {
        self.manager = biomeManager
        self.biomes = Array(biomeManager.biomes)
    }
    
    fileprivate func biome(at index: Int) -> Biome? {
        guard index >= 0 && index < self.biomes.count else {
            return nil
        }
        
        return self.biomes[index]
    }
    
    fileprivate func viewModel(for biome: Biome) -> BiomeViewModel {
        let isActive = self.manager?.current == biome
        let string = biome.count == 1 ? "%d key" : "%d keys"
        return BiomeViewModel(name: biome.name,
                              subtitle: String.init(format: string, biome.count),
                              active: isActive)
    }
}

// MARK: -
// MARK: UITableViewDataSource
extension BiomeDataSource: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.biomes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cell(tableView: tableView)
        if let biome = self.biome(at: indexPath.row) {
            let viewModel = self.viewModel(for: biome)
            cell.update(with: viewModel)
        }
        
        return cell
    }
    
    private func cell(tableView: UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        return cell!
    }
}

// MARK: -
// MARK: UITableViewDelegate
extension BiomeDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let biome = self.biome(at: indexPath.row)
        self.manager?.current = biome
        
        var indexSet = IndexSet()
        indexSet.insert(0)
        
        tableView.reloadSections(indexSet, with: .automatic)
    }
}

// MARK: -
// MARK: Random view stuff
fileprivate struct BiomeViewModel {
    var name: String
    var subtitle: String
    var active: Bool
}

extension UITableViewCell {
    fileprivate func update(with viewModel: BiomeViewModel) {
        self.textLabel?.text = viewModel.name
        self.detailTextLabel?.text = viewModel.subtitle
        self.accessoryType = viewModel.active ? .checkmark : .none
    }
}
#endif
