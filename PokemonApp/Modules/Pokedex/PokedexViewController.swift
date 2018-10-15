//
//  PokedexViewController.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class PokedexViewController: BaseViewController {

    private var pokemonList: PokemonList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUILayout()
        registerCells()
        loadPokemonsIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func registerCells() {
        tableView.register(PokedexTableViewCell.self, forCellReuseIdentifier: PokedexTableViewCell.reuseIdentifier)
    }
    
    private func setupUILayout() {
        title = "Pokedex"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .clear

        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func loadPokemonsIfNeeded() {
        startLoading()
        NetworkService.getPokemons { [weak self] (result, error) in
            self?.stopLoading()
            
            if let _ = error {
                
                return
            }
            if let result = result {
                self?.pokemonList = PokemonList.model(fromResponseModel: result)
            }
        }
    }
}

extension PokedexViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList?.list.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokedexTableViewCell.reuseIdentifier, for: indexPath) as! PokedexTableViewCell
        if let pokemonNames = pokemonList?.list.map({ $0.pokemonName }) {
            let row = indexPath.row
            cell.setup(position: row + 1, name: pokemonNames[row])
        }
        
        return cell
    }

}

extension PokedexViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPokemon = pokemonList?.list[indexPath.row] {
            let pokemonDetailViewController = PokemonDetailViewController(pokemonName: selectedPokemon.pokemonName, pokemonId: selectedPokemon.pokemonId)
            navigationController?.pushViewController(pokemonDetailViewController, animated: true)
        }
    }
    
}
