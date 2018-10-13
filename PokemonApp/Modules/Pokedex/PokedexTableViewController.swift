//
//  PokedexTableViewController.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class PokedexTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PokedexTableViewCellId"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setup(position: Int, name: String) {
        setupUILayout()
        nameLabel.text = String(describing: position) + ". " + name
    }
    
    private func setupUILayout() {
        addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
}

class PokedexTableViewController: UITableViewController {

    private var pokemonList: PokemonList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pokedex"
        navigationController?.navigationBar.prefersLargeTitles = true
        registerCells()
        loadPokemonsIfNeeded()
    }

    private func registerCells() {
        tableView.register(PokedexTableViewCell.self, forCellReuseIdentifier: PokedexTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList?.pokemonNames.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokedexTableViewCell.reuseIdentifier, for: indexPath) as! PokedexTableViewCell
        
        if let pokemonNames = pokemonList?.pokemonNames {
            let row = indexPath.row
            cell.setup(position: row + 1, name: pokemonNames[row])
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPokemonName = pokemonList?.pokemonNames[indexPath.row] {
            let pokemonDetailViewController = PokemonDetailViewController(pokemonName: selectedPokemonName)
            navigationController?.pushViewController(pokemonDetailViewController, animated: true)
        }
    }

    private func loadPokemonsIfNeeded() {
        // Start Loading
        NetworkService.getPokemons { [weak self] (result, error) in
            // Stop loading
            if let _ = error {
                
                return
            }
            if let result = result {
                self?.pokemonList = PokemonList.model(fromResponseModel: result)
            }
        }
    }
}
