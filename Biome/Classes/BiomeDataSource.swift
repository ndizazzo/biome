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
public class BiomeDataSource<T: Biome>: NSObject, UITableViewDataSource, UITableViewDelegate {
    internal weak var manager: BiomeManager?
    internal var biomeData: [BiomeData] = []
    
    public init(biomeManager: BiomeManager) {
        self.manager = biomeManager
        if let group = biomeManager.group(for: HashableType<T>()) {
            biomeData = group.biomeData
        }
    }
    
    fileprivate func data(at index: Int) -> BiomeData? {
        guard index >= 0 && index < self.biomeData.count else {
            return nil
        }
        
        return self.biomeData[index]
    }
    
    fileprivate func viewModel(for data: BiomeData) -> BiomeViewModel {
        let currentBiome = self.manager?.current(for: T.self)
        let isActive = currentBiome?.identifier == data.identifier

        let string = 1 == data.keys ? "%d key" : "%d keys"
        return BiomeViewModel(name: data.identifier,
                              subtitle: String.init(format: string, data.keys),
                              active: isActive)
    }

    // MARK: -
    // MARK: UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.biomeData.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cell(tableView: tableView)
        if let biome = self.data(at: indexPath.row) {
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

    // MARK: -
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try manager?.select(type: T.self, index: indexPath.row)
        } catch let error {
            print("ERROR: \(error)")
        }

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
